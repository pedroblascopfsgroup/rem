<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page>

    var usuarioId = new Ext.form.Hidden({name: 'id', value:${usuario.id}});
    
    var login = app.creaText('username',
                             '<s:message code="usuario.username" text="**Usuario" />', 
                             '${usuario.username}',
                             {allowBlank : false,readOnly:true});

    var username = app.creaText('nombre',
                                '<s:message code="usuario.nombre" text="**Nombre" />',
                                '${usuario.nombre}');

    var apellido1 = app.creaText('apellido1',
                                 '<s:message code="usuario.apellido1" text="**Apellido 1" />',
                                '${usuario.apellido1}');
    
    var apellido2 = app.creaText('apellido2',
                                 '<s:message code="usuario.apellido2" text="**Apellido 2" />',
                                 '${usuario.apellido2}');
    


    var password = app.creaText('password',
                             '<s:message code="usuario.passwordActual" text="**Password actual" />', 
                             '',
                             {allowBlank : false, inputType:'password'});


    var passwordNuevo = app.creaText('passwordNuevo',
                                     '<s:message code="usuario.passwordNueva" text="**Nueva password" />',
                                     '',{inputType:'password'});

	passwordNuevo.validator = function(v) {
			return /^[a-zA-Z0-9]{3,16}$/.test(v)? true : '<s:message code="usuario.validacionPassword" text="**Debe introducir una contraseña compuesta entre 4 y 16 caracteres alfanumericos" />';
	};
    var passwordNuevoVerificado = app.creaText('passwordNuevoVerificado',
                                               '<s:message code="usuario.passwordNuevaVerificada" text="**Repita nueva password" />',
                                               '',{inputType:'password'});

    var email = app.creaText('email',
                             '<s:message code="usuario.email" text="**E-Mail" />',
                             '${usuario.email}');
    
    var telefono = app.creaText('telefono',
                             '<s:message code="usuario.telefono" text="**Teléfono" />',
                             '${usuario.telefono}');


    var fechaVigencia = new Ext.ux.form.StaticTextField({
                    fieldLabel:'<s:message code="usuario.fechaVigencia" text="**Fecha de vigencia" />'
                    ,value:'<fwk:date value="${usuario.fechaVigenciaPassword}" />'
                });

    var fechaVigenciaNueva = new Ext.ux.form.StaticTextField({
                    fieldLabel:'<s:message code="usuario.fechaVigenciaNueva" text="**Nueva fecha de vigencia" />'
                     ,value:'<fwk:date value="${usuario.nuevaFechaVigenciaPassword}" />'
                });


    var lRecordatorio = new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,style:'font-weight:bolder'
                    ,value:'<s:message code="usuario.recordatorio" text="**Es necesario volver"/>'
                });

    var lPassVencido = new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,style:'font-weight:bolder'
                    ,value:'<s:message code="usuario.passwordVencido" text="**Es necesario volver"/>'
                });

    var nombresFieldSet = new Ext.form.FieldSet({
            autoHeight:true
            ,style:'padding:0px;padding-top:15px'
            ,layout : 'table'
            ,border : true
            ,layoutConfig:{columns:2}
            ,defaults : {xtype : 'fieldset', autoHeight : true, border : false }
            ,items : [<c:if test="${passExpired}">{items:[lPassVencido],colspan:2},</c:if>
                      {items:[login,username]},
                      {items:[apellido1,apellido2]}
                     ]
        });

    var passFecha = new Ext.form.FieldSet({
            style:'padding:0px'
            ,layout : 'table'
            ,border : false
            ,layoutConfig:{columns:2}
            ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
            ,items : [{items:[password]},{items:[fechaVigencia]}]
        });

    var passFechaNuevo = new Ext.form.FieldSet({
            style:'padding:0px'
            ,layout : 'table'
            ,border : false
            ,layoutConfig:{columns:2}
            ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',padding:'0px'}
            ,items : [{items:[passwordNuevo]},{items:[fechaVigenciaNueva]}]
        });


    var passwordFieldSet = new Ext.form.FieldSet({
            autoHeight:true            
            ,style:'padding:0px'
            ,border : true
            ,defaults : {xtype : 'fieldset', autoHeight:true, border : false ,cellCls : 'vtop'}
            //,items : [lRecordatorio,passFecha,passFechaNuevo,passwordNuevoVerificado, email,telefono]
            ,layoutConfig:{columns:2}
            ,layout : 'table'
            ,items : [{items:[lRecordatorio],colspan:2}
                     ,{items:[password,passwordNuevo,passwordNuevoVerificado]}
                     ,{items:[fechaVigencia,fechaVigenciaNueva]}
                     ,{items:[email,telefono],colspan:2}
            ]
        });    

	var items={	
			border : false
			,autoScroll:true
			,bodyStyle:'padding:5px'
			,autoHeight:true
			,autoWidth : true
			,items:[nombresFieldSet,passwordFieldSet,usuarioId]  
		};
    
    


    app.crearABMWindow(page , items);
</fwk:page>