using btp.demo as bd from '../db/data-model';

service EmployeeService {
    entity Employees @(
        Capabilities : {
            InsertRestrictions : {
                $Type : 'Capabilities.InsertRestrictionsType',
                Insertable,
            },
            UpdateRestrictions : {
                $Type : 'Capabilities.UpdateRestrictionsType',
                Updatable
            },
            DeleteRestrictions : {
                $Type : 'Capabilities.DeleteRestrictionsType',
                Deletable
            }
        }
    ) as select from bd.EMPLOYEE_REGISTRY;

    annotate Employees with @odata.draft.enabled;

    entity Department as select from bd.DEPARTMENT;

    annotate Department with @odata.draft.enabled;
}


annotate EmployeeService.Employees with @(UI : {
    LineItem            : [
        {
            $Type : 'UI.DataField',
            Value : NAME
        },
        {
            $Type : 'UI.DataField',
            Value : EMAIL_ID
        },
        {
            $Type : 'UI.DataField',
            Value : DEPARTMENT_ID
        }
    ],
    SelectionFields     : [DEPARTMENT_ID],

    HeaderInfo          : {
        TypeName       : 'Employee',
        TypeNamePlural : 'Employees',
        Title          : {Value : NAME},
        Description    : {Value : DEPARTMENT.NAME}
    },

    Facets              : [{
        $Type  : 'UI.ReferenceFacet',
        Label  : 'General',
        Target : '@UI.FieldGroup#Default',
        ID     : 'Default'
    }, {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Admin Data',
        Target : '@UI.FieldGroup#Admin',
        ID     : 'Admin'
    }],

    FieldGroup #Default : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : NAME
            },
            {
                $Type : 'UI.DataField',
                Value : EMAIL_ID
            },
            {
                $Type : 'UI.DataField',
                Value : DEPARTMENT_ID
            }
        ]
    },

    FieldGroup #Admin : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : createdAt
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedAt
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy
            }             
        ]
    }
}) {
    NAME          @(title : 'Name');
    EMAIL_ID      @(title : 'Email Id');
    DEPARTMENT    @(title : 'Department' );

    // Valuelist
    DEPARTMENT        @(
        Common.ValueListWithFixedValues : true,
        Common.ValueList                : {
            CollectionPath : 'Department',
            Label          : 'Departments',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : DEPARTMENT_ID,
                    ValueListProperty : 'ID'
                }
            ]
        },
        // Common.Text                     : DEPARTMENT.NAME @(
        //     UI.TextArrangement          : #TEXT_ONLY
        // )
        
        Common : {
            Text : DEPARTMENT.NAME,
            TextArrangement : #TextOnly, 
        }
    );    
};

annotate EmployeeService.Department {
    ID          @(
        sap.text           : 'NAME',
        Common : {
            Text : NAME,
            TextArrangement : #TextOnly, 
        }        
        //UI.Textarrangement : #TEXT_ONLY
    );
    NAME                    @(title : 'Department');

};