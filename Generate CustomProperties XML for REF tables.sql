
SET NOCOUNT ON

SELECT  '<Factory class-name="' + TABLE_NAME + 'Factory" factory-type="entity_factory" base-entity-class="' + TABLE_NAME + 'Entity">'
       ,'<Method cs-method-name="RetrieveAll" method-type="search" cs-return-type="' + TABLE_NAME + 'Entity" executor-name="' + TABLE_NAME + 'RetrieveAll" search-criteria-class="' + COLUMN_NAME + 'Criteria">'
       ,'<Parameters>'
       ,'<Param cs-param-name="' + COLUMN_NAME + '" cs-data-type="int" criteria-property="' + COLUMN_NAME + '" />'
       ,'</Parameters>'
       ,'<ResultSet />'
       ,'</Method>'
       ,'</Factory>'
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE   COLUMN_NAME LIKE '%ID'
        AND COLUMN_NAME <> TABLE_NAME + 'ID'
        AND TABLE_NAME NOT IN ('sysdiagrams')
        AND TABLE_NAME LIKE 'Ref%'
        AND (TABLE_SCHEMA = 'iCCG' OR (TABLE_SCHEMA = 'dbo' AND (TABLE_NAME = 'GuidelineSection' OR TABLE_NAME = 'GuidelineCache')))
ORDER BY TABLE_NAME
       ,COLUMN_NAME
