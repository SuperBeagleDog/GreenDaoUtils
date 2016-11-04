<#--

Copyright (C) 2011-2016 Markus Junginger, greenrobot (http://greenrobot.org)
                                                                           
This file is part of greenDAO Generator.                                   
                                                                           
greenDAO Generator is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by       
the Free Software Foundation, either version 3 of the License, or          
(at your option) any later version.                                        
greenDAO Generator is distributed in the hope that it will be useful,      
but WITHOUT ANY WARRANTY; without even the implied warranty of             
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              
GNU General Public License for more details.                               
                                                                           
You should have received a copy of the GNU General Public License          
along with greenDAO Generator.  If not, see <http://www.gnu.org/licenses/>.

-->
<#-- @ftlvariable name="entity" type="org.greenrobot.greendao.generator.Entity" -->
<#-- @ftlvariable name="schema" type="org.greenrobot.greendao.generator.Schema" -->

<#assign toBindType = {"Boolean":"Long", "Byte":"Long", "Short":"Long", "Int":"Long", "Long":"Long", "Float":"Double", "Double":"Double", "String":"String", "ByteArray":"Blob" }/>
<#assign toCursorType = {"Boolean":"Short", "Byte":"Short", "Short":"Short", "Int":"Int", "Long":"Long", "Float":"Float", "Double":"Double", "String":"String", "ByteArray":"Blob" }/>
<#assign primitiveTypes = ["boolean", "byte", "int", "long", "float", "double", "short"]/>
<#macro multiIndexes>
{
<#list entity.multiIndexes as index>
    @Index(value = "${index.orderSpec}"<#if index.nonDefaultName>, name = "${index.name}"</#if><#if index.unique>, unique = true</#if>)<#sep>,
</#list>

}</#macro>
package ${entity.javaPackage};

import org.greenrobot.greendao.annotation.*;

<#if entity.toManyRelations?has_content>
import java.util.List;
</#if>
<#if entity.active>
import ${schema.defaultJavaPackageDao}.${schema.prefix}DaoSession;
import org.greenrobot.greendao.DaoException;

</#if>
<#if entity.additionalImportsEntity?has_content>
<#list entity.additionalImportsEntity as additionalImport>
import ${additionalImport};
</#list>

</#if>
<#if entity.hasKeepSections>
// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
<#if keepIncludes?has_content>${keepIncludes!}</#if>// KEEP INCLUDES END
<#else>
// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT. Enable "keep" sections if you want to edit.
</#if>

<#if entity.javaDoc ??>
${entity.javaDoc}
<#else>
/**
 * Entity mapped to table "${entity.dbName}".
 */
</#if>
<#if entity.codeBeforeClass ??>
${entity.codeBeforeClass}
</#if>
<#assign entityAttrs = []>
<#if schema.name != "default"><#assign entityAttrs = entityAttrs + ["schema = \"${schema.name}\""]></#if>
<#if entity.active><#assign entityAttrs = entityAttrs + ["active = true"]></#if>
<#if entity.nonDefaultDbName><#assign entityAttrs = entityAttrs + ["nameInDb = \"${entity.dbName}\""]></#if>
<#if (entity.multiIndexes?size > 0)>
    <#assign idxAttr>indexes = <@multiIndexes/></#assign>
    <#assign entityAttrs = entityAttrs + [idxAttr]>
</#if>
public class ${entity.className}<#if
entity.superclass?has_content> extends ${entity.superclass} </#if><#if
entity.interfacesToImplement?has_content> implements <#list entity.interfacesToImplement
as ifc>${ifc}<#if ifc_has_next>, </#if></#list></#if> {
<#list entity.properties as property>
<#assign notNull = property.notNull && !primitiveTypes?seq_contains(property.javaTypeInEntity)>
<#if property.primaryKey||notNull||property.unique||property.index??||property.nonDefaultDbName||property.converter??>

</#if>
<#if property.javaDocField ??>
${property.javaDocField}
</#if>
<#if property.codeBeforeField ??>
    ${property.codeBeforeField}
</#if>
<#if property.primaryKey>
    @Id<#if property.autoincrement>(autoincrement = true)</#if>
</#if>
<#if property.nonDefaultDbName>
    @Property(nameInDb = "${property.dbName}")
</#if>
<#if property.converter??>
    @Convert(converter = ${property.converter}.class, columnType = ${property.javaType}.class)
</#if>
<#if notNull>
    @NotNull
</#if>
<#if property.unique>
    @Unique
</#if>
<#if ((property.index.nonDefaultName)!false) && (property.index.unique)!false>
    @Index(name = "${property.index.name}", unique = true)
<#elseif (property.index.nonDefaultName)!false>
    @Index(name = "${property.index.name}")
<#elseif (property.index.unique)!false>
    @Index(unique = true)
<#elseif property.index??>
    @Index
</#if>
    private ${property.javaTypeInEntity} ${property.propertyName};
</#list>

<#if entity.active>
    /** Used to resolve relations */
    @Generated
    private transient ${schema.prefix}DaoSession daoSession;

    /** Used for active entity operations. */
    @Generated
    private transient ${entity.classNameDao} myDao;
<#list entity.toOneRelations as toOne>

<#if toOne.useFkProperty>
    @ToOne(joinProperty = "${toOne.fkProperties[0].propertyName}")
    private ${toOne.targetEntity.className} ${toOne.name};

    @Generated
    private transient ${toOne.resolvedKeyJavaType[0]} ${toOne.name}__resolvedKey;
<#else>
    @ToOne
<#if toOne.fkProperties[0].nonDefaultDbName>
    @Property(nameInDb = "${toOne.fkProperties[0].dbName}")
</#if>
<#if toOne.fkProperties[0].unique>
    @Unique
</#if>
<#if toOne.fkProperties[0].notNull>
    @NotNull
</#if>
    private ${toOne.targetEntity.className} ${toOne.name};

    @Generated
    private transient boolean ${toOne.name}__refreshed;
</#if>
</#list>
<#list entity.toManyRelations as toMany>

<#if toMany.sourceProperties??>
    @ToMany(joinProperties = {
<#list toMany.sourceProperties as sourceProperty>
        @JoinProperty(name = "${sourceProperty.propertyName}", referencedName = "${toMany.targetProperties[sourceProperty_index].propertyName}")<#sep>,
</#list>

    })
<#elseif toMany.targetProperties??>
    @ToMany(mappedBy = "${toMany.targetProperties[0]}")
<#else>
    @ToMany
    @JoinEntity(entity = ${toMany.joinEntity.className}.class, sourceProperty = "${toMany.sourceProperty.propertyName}", targetProperty = "${toMany.targetProperty.propertyName}")
</#if>
<#assign orderSpec = (toMany.orderSpec)!"0">
<#if orderSpec != "0">
    @OrderBy("${orderSpec}")
</#if>
    private List<${toMany.targetEntity.className}> ${toMany.name};
</#list>

</#if>
<#if entity.hasKeepSections>
    // KEEP FIELDS - put your custom fields here
${keepFields!}    // KEEP FIELDS END

</#if>
<#if entity.constructors>
    @Generated
    public ${entity.className}() {
    }
<#if entity.propertiesPk?has_content && entity.propertiesPk?size != entity.properties?size>

    public ${entity.className}(<#list entity.propertiesPk as
property>${property.javaType} ${property.propertyName}<#if property_has_next>, </#if></#list>) {
<#list entity.propertiesPk as property>
        this.${property.propertyName} = ${property.propertyName};
</#list>
    }
</#if>

    @Generated
    public ${entity.className}(<#list entity.properties as
property>${property.javaTypeInEntity} ${property.propertyName}<#if property_has_next>, </#if></#list>) {
<#list entity.properties as property>
        this.${property.propertyName} = ${property.propertyName};
</#list>
    }
</#if>

<#if entity.active>
    /** called by internal mechanisms, do not call yourself. */
    @Generated
    public void __setDaoSession(${schema.prefix}DaoSession daoSession) {
        this.daoSession = daoSession;
        myDao = daoSession != null ? daoSession.get${entity.classNameDao?cap_first}() : null;
    }

</#if>
<#list entity.properties as property>
<#if property.javaDocGetter ??>
${property.javaDocGetter}
</#if>
<#if property.codeBeforeGetter ??>
    ${property.codeBeforeGetter}
</#if>
<#if property.notNull && !primitiveTypes?seq_contains(property.javaTypeInEntity)>
    @NotNull
</#if>
    public ${property.javaTypeInEntity} get${property.propertyName?cap_first}() {
        return ${property.propertyName};
    }

<#if property.notNull && !primitiveTypes?seq_contains(property.javaTypeInEntity)>
    /** Not-null value; ensure this value is available before it is saved to the database. */
</#if>
<#if property.javaDocSetter ??>
${property.javaDocSetter}
</#if>
<#if property.codeBeforeSetter ??>
    ${property.codeBeforeSetter}
</#if>
    public void set${property.propertyName?cap_first}(<#if property.notNull && !primitiveTypes?seq_contains(property.javaTypeInEntity)>@NotNull </#if>${property.javaTypeInEntity} ${property.propertyName}) {
        this.${property.propertyName} = ${property.propertyName};
    }

</#list>
<#--
##########################################
########## To-One Relations ##############
##########################################
-->
<#list entity.toOneRelations as toOne>
    /** To-one relationship, resolved on first access. */
    @Generated
    public ${toOne.targetEntity.className} get${toOne.name?cap_first}() {
<#if toOne.useFkProperty>
        ${toOne.fkProperties[0].javaType} __key = this.${toOne.fkProperties[0].propertyName};
        if (${toOne.name}__resolvedKey == null || <#--
        --><#if toOne.resolvedKeyUseEquals[0]>!${toOne.name}__resolvedKey.equals(__key)<#--
        --><#else>${toOne.name}__resolvedKey != __key</#if>) {
            __throwIfDetached();
            ${toOne.targetEntity.classNameDao} targetDao = daoSession.get${toOne.targetEntity.classNameDao?cap_first}();
            ${toOne.targetEntity.className} ${toOne.name}New = targetDao.load(__key);
            synchronized (this) {
                ${toOne.name} = ${toOne.name}New;
            	${toOne.name}__resolvedKey = __key;
            }
        }
<#else>
        if (${toOne.name} != null || !${toOne.name}__refreshed) {
            __throwIfDetached();
            ${toOne.targetEntity.classNameDao} targetDao = daoSession.get${toOne.targetEntity.classNameDao?cap_first}();
            targetDao.refresh(${toOne.name});
            ${toOne.name}__refreshed = true;
        }
</#if>
        return ${toOne.name};
    }
<#if !toOne.useFkProperty>

    /** To-one relationship, returned entity is not refreshed and may carry only the PK property. */
    @Generated
    public ${toOne.targetEntity.className} peak${toOne.name?cap_first}() {
        return ${toOne.name};
    }
</#if>

    @Generated
    public void set${toOne.name?cap_first}(<#if toOne.fkProperties[0].notNull && !primitiveTypes?seq_contains(toOne.fkProperties[0].javaTypeInEntity)>@NotNull </#if>${toOne.targetEntity.className} ${toOne.name}) {
<#if toOne.fkProperties[0].notNull>
        if (${toOne.name} == null) {
            throw new DaoException("To-one property '${toOne.fkProperties[0].propertyName}' has not-null constraint; cannot set to-one to null");
        }
</#if>
        synchronized (this) {
            this.${toOne.name} = ${toOne.name};
<#if toOne.useFkProperty>        
            ${toOne.fkProperties[0].propertyName} = <#if !toOne.fkProperties[0].notNull>${toOne.name} == null ? null : </#if>${toOne.name}.get${toOne.targetEntity.pkProperty.propertyName?cap_first}();
            ${toOne.name}__resolvedKey = ${toOne.fkProperties[0].propertyName};
<#else>
            ${toOne.name}__refreshed = true;
</#if>
        }
    }

</#list>
<#--
##########################################
########## To-Many Relations #############
##########################################
-->
<#list entity.toManyRelations as toMany>
    /** To-many relationship, resolved on first access (and after reset). Changes to to-many relations are not persisted, make changes to the target entity. */
    @Generated
    public List<${toMany.targetEntity.className}> get${toMany.name?cap_first}() {
        if (${toMany.name} == null) {
            __throwIfDetached();
            ${toMany.targetEntity.classNameDao} targetDao = daoSession.get${toMany.targetEntity.classNameDao?cap_first}();
            List<${toMany.targetEntity.className}> ${toMany.name}New = targetDao._query${toMany.sourceEntity.className?cap_first}_${toMany.name?cap_first}(<#--
                --><#if toMany.sourceProperties??><#list toMany.sourceProperties as property>${property.propertyName}<#if property_has_next>, </#if></#list><#else><#--
                -->${entity.pkProperty.propertyName}</#if>);
            synchronized (this) {<#-- Check if another thread was faster, we cannot lock while doing the query to prevent deadlocks -->
                if(${toMany.name} == null) {
                    ${toMany.name} = ${toMany.name}New;
                }
            }
        }
        return ${toMany.name};
    }

    /** Resets a to-many relationship, making the next get call to query for a fresh result. */
    @Generated
    public synchronized void reset${toMany.name?cap_first}() {
        ${toMany.name} = null;
    }

</#list>
<#--
##########################################
########## Active entity operations ######
##########################################
-->
<#if entity.active>
    /**
    * Convenient call for {@link org.greenrobot.greendao.AbstractDao#delete(Object)}.
    * Entity must attached to an entity context.
    */
    @Generated
    public void delete() {
        __throwIfDetached();
        myDao.delete(this);
    }

    /**
    * Convenient call for {@link org.greenrobot.greendao.AbstractDao#update(Object)}.
    * Entity must attached to an entity context.
    */
    @Generated
    public void update() {
        __throwIfDetached();
        myDao.update(this);
    }

    /**
    * Convenient call for {@link org.greenrobot.greendao.AbstractDao#refresh(Object)}.
    * Entity must attached to an entity context.
    */
    @Generated
    public void refresh() {
        __throwIfDetached();
        myDao.refresh(this);
    }

    @Generated
    private void __throwIfDetached() {
        if (myDao == null) {
            throw new DaoException("Entity is detached from DAO context");
        }
    }

</#if>
<#if entity.hasKeepSections>
    // KEEP METHODS - put your custom methods here
${keepMethods!}    // KEEP METHODS END

</#if>
}
