<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


var creaText = function(name, label, value, config){
    var cfg = config || {};
    cfg.name = name;
    cfg.value = value;
    cfg.fieldLabel = label;
    return new Ext.form.TextField(cfg);
};


var createDatosUsuarioPanel= function(usuario){

	Ext.QuickTips.init();
    
    var username = creaText('username','Usuario',usuario.username,{allowBlank : false});
    var nombre = creaText('nombre','Nombre',usuario.nombre);
    var apellido1 = creaText('apellido1','Apellido 1',usuario.apellido1);
    var apellido2 = creaText('apellido2','Apellido 2',usuario.apellido2);

    var password = creaText('password','Password actual','',{allowBlank : false, inputType:'password'});
    var passwordNuevo = creaText('passwordNuevo','Nueva password','',{inputType:'password'});
    var passwordNuevoVerificado = creaText('passwordNuevoVerificado','Repita nueva password','',{inputType:'password'});
    var email = creaText('email','E-Mail',usuario.email);    
    var telefono = creaText('telefono','Teléfono',usuario.telefono);

	passwordNuevo.validator = function(v) {
			return /^[a-zA-Z0-9]{3,16}$/.test(v)? true : '<s:message code="usuario.validacionPassword" text="**Debe introducir una contraseña compuesta entre 4 y 16 caracteres alfanumericos" />';
	};


    var lPassVencido = new Ext.ux.form.StaticTextField({
                            hideLabel:true
                            ,style:'font-weight:bolder'
                            ,value:'<s:message code="usuario.passwordVencido" text="**Es necesario volver"/>'
                });

    var fechaVigencia = new Ext.ux.form.StaticTextField({
                    fieldLabel:'Fecha de vigencia'
                    ,value:usuario.fechaVigenciaPassword
                });

    var fechaVigenciaNueva = new Ext.ux.form.StaticTextField({
                    fieldLabel:'Nueva fecha de vigencia'
                     ,value:usuario.nuevaFechaVigenciaPassword
                });

    var lRecordatorio = new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,style:'font-weight:bolder'
                    ,value:'<s:message code="usuario.recordatorio" text="**Es necesario volver"/>'
                });

    var nombresFieldSet = new Ext.form.FieldSet({
            autoHeight:true
            ,style:'padding:0px'
            ,layout : 'table'
            ,border : true
            ,layoutConfig:{columns:2}
            ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
            ,items : [{items:[lPassVencido],colspan:2},
                      {items:[username,apellido1]},
                      {items:[nombre,apellido2]}
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
		

    var btnCancelar= new Ext.Button({
        text : 'Cancelar'
        ,iconCls : 'icon_cancel'
        ,handler : function(){
                cambiarDatosWindow.close();
                loginWindow.show()
        }
    });

    var btnAceptar= new Ext.Button({
        text : 'Aceptar'
        ,iconCls : 'icon_ok'
        ,handler : function(target, e){
        	
        	if (passwordNuevo.validate() != true)
       		{
       			Ext.Msg.alert('<s:message code="app.error" text="**Error" />','<s:message code="usuario.validacionPassword" text="**Debe introducir una contraseña compuesta entre 4 y 16 caracteres alfanumericos" />');
       			return;
       		}
        
            webflow({
                flow:'public/guardarUsuario.htm'
                ,params: {id:usuario.id
                        ,username: username.getValue()
                        ,nombre: nombre.getValue()
                        ,apellido1: apellido1.getValue()
                        ,apellido2: apellido2.getValue()
                        ,password: password.getValue()
                        ,passwordNuevo: passwordNuevo.getValue()
                        ,passwordNuevoVerificado: passwordNuevoVerificado.getValue()
                        ,email: email.getValue()
                        ,telefono: telefono.getValue()
                }
                ,success: function(data, config) {
                    if(data.respuesta.respuesta=='OK') {
                        cambiarDatosWindow.close();
                        loginWindow.show()
                        Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="admin.users.update.ok" text="**El usuario ha sido actualizado correctamente" />');
                    }else{
                    	Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />',data.respuesta.respuesta);
                    }
                    messageService.getMessage("")
                }
            });
        }
    });

	//Panel propiamente dicho...
	var panel=new Ext.form.FormPanel({
		autoScroll:true
		,autoHeight:true
		,layout:'form'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items:[nombresFieldSet,passwordFieldSet]
        ,bbar : [btnAceptar, btnCancelar]
	});
	
	return panel;
};
