public with sharing class ParentRelationshipCache {

    static final Map<SObjectType, Map<String, SObjectField>> relationships =
        new Map<SObjectType, Map<String, SObjectField>>();

    public static SObjectField get(SObjectType sObjType, String name) {
        if (relationships.containsKey(sObjectType)) {
            return relationships.get(sObjectType).get(name);
        }
        Map<String, SObjectField> parents = getParentRelationships(sObjType);
        relationships.put(sObjType, parents);
        return parents.get(name);
    }

    private static Map<String, SObjectField> getParentRelationships(sObjectType sObjType) {
        Map<String, SObjectField> parents = new Map<String, SObjectField>();
        for (Schema.SobjectField field : sObjectType.getDescribe().fields.getMap().values()) {
            if (field.getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                parents.put(field.getDescribe().getRelationshipName(), field);
            } 
        }
        return parents;
    }

}