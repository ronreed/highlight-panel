public with sharing class HighlightPanelController {

    @AuraEnabled
    public static List<HighlightPanelResultItem> getFieldResultItems(
        Id recordId,
        String fieldSetName
    ) {
        SObjectType sObjType = recordId.getSObjectType();
        FieldSetDefinition definition = new FieldSetDefinition(
                sObjType,
                fieldSetName
            )
            .init();
        SObject record = getRecord(recordId, definition);
        List<HighlightPanelResultItem> resultItems = new List<HighlightPanelResultItem>();
        for (
            FieldSetDefinition.Member member : definition.members.values()
        ) {
            resultItems.add(
                new HighlightPanelResultItem(
                    (Id) record.get(member.idFieldName),
                    member.objectName,
                    member.fieldName,
                    member.fieldLabel
                )
            );
        }
        return resultItems;
    }

    private static SObject getRecord(
        Id recordId,
        FieldSetDefinition definition
    ) {
        String soql =
            'SELECT ' +
            String.join(definition.getFieldPaths(), ', ') +
            ' FROM ' +
            recordId.getSObjectType().getDescribe().getName() +
            ' WHERE Id = :recordId';
        return Database.query(soql);
    }

    
    public class HighlightPanelResultItem {
        @AuraEnabled
        public Id recordId {get; private set;}
        @AuraEnabled
        public String objectApiName {get; private set;}
        @AuraEnabled
        public String fieldName {get; private set;}
        @AuraEnabled
        public String fieldLabel {get; private set;}
        public HighlightPanelResultItem(Id recordId, String objectApiName, String fieldName, String fieldLabel) {
            this.recordId = recordId;
            this.objectApiName = objectApiName;
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
        } 
    }

}