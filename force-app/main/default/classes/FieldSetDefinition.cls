public class FieldSetDefinition {
    private SObjectType sObjType;
    private String fieldSetName;
    public Map<String, Member> members { get; private set; }
    private static final String ID_FIELD_NAME = 'Id';

    public FieldSetDefinition(SObjectType sObjType, String fieldSetName) {
        this.sObjType = sObjType;
        this.fieldSetName = fieldSetName;
    }

    public FieldSetDefinition init() {
        this.members = getMembers();
        return this;
    }

    public Member get(String fieldPath) {
        return this.members.get(fieldPath);
    }

    public Map<String, Member> getMembers() {
        Map<String, Member> members = new Map<String, Member>();
        for (
            Schema.FieldSetMember field : this.sObjType.getDescribe()
                .fieldSets.getMap()
                .get(this.fieldSetName)
                .getFields()
        ) {
            Member member = new Member(field);
            members.put(member.fieldPath, member);
        }
        return members;
    }

    public List<String> getFieldPaths() {
        List<String> fieldPaths = new List<String>();
        for (String fieldPath : this.members.keySet()) {
            fieldPaths.add(fieldPath);
        }
        return fieldPaths;
    }

    public class Member {
        public String objectName;
        public String fieldPath;
        public String fieldName;
        public String fieldLabel;
        public String idFieldName;

        public Member(FieldSetMember member) {
            SObjectField sObjField = member.getSObjectField();
            SObjectType sObjType = sObjField.getDescribe().getSObjectType();
            this.objectName = sObjType.getDescribe().getName();
            this.fieldPath = member.getFieldPath();
            this.fieldName = sObjField.getDescribe().getName();
            this.fieldLabel = getCleanedFieldLabel(sObjField);
            if (this.fieldPath.contains('.')) {
                String parentRelationshipName = this.fieldPath.substringBefore(
                    '.'
                );
                SObjectField idField = ParentRelationshipCache.get(
                    sObjType,
                    parentRelationshipName
                );
                this.idFieldName = idField.getDescribe().getName();
                this.fieldLabel = String.format(
                    '{0}: {1}',
                    new List<String>{
                        getCleanedFieldLabel(idField),
                        this.fieldLabel
                    }
                );
            } else {
                this.idFieldName = ID_FIELD_NAME;
            }
        }

        private String getCleanedFieldLabel(SObjectField sObjField) {
            String fieldLabel = sObjField.getDescribe().getLabel();
            return sObjField.getDescribe().getType() ==
                Schema.DisplayType.REFERENCE
                ? fieldLabel.removeEndIgnoreCase(ID_FIELD_NAME).trim()
                : fieldLabel;
        }
    }
}
