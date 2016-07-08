<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
// ---- campos del formulario ---
	var username = new Ext.form.TextField({
		name : 'usuario.nombre'
		,value : '<s:message text="${usuario.nombre}" javaScriptEscape="true" />'
		,fieldLabel : 'Nombre'
		,allowBlank : false
	});
	
	var login = new Ext.form.TextField({
		name : 'usuario.username'
		,value : '<s:message text="${usuario.username}" javaScriptEscape="true" />'
		,fieldLabel : 'login'
	});
	
	var password = new Ext.form.TextField({
		name : 'usuario.password'
		,value : '<s:message text="${usuario.password}" javaScriptEscape="true" />'
		,fieldLabel : 'password'
	});

	var apellido1 = new Ext.form.TextField({
		name : 'usuario.apellido1'
		,value : '<s:message text="${usuario.apellido1}" javaScriptEscape="true" />'
		,fieldLabel : 'apellido1'
	});
	
	var apellido2 = new Ext.form.TextField({
		name : 'usuario.apellido2'
		,value : '<s:message text="${usuario.apellido2}" javaScriptEscape="true" />'
		,fieldLabel : 'apellido2'
	});
	
	var email = new Ext.form.TextField({
		name : 'usuario.email'
		,value : '<s:message text="${usuario.email}" javaScriptEscape="true" />'
		,fieldLabel : 'email'
	});
	
	
	var alta = new Ext.ux.form.XDateField({
		name : 'usuario.alta'
		,fieldLabel : '<s:message code="admin.user.alta" />'
		,value : '<fwk:date value="${usuario.alta}" />'
		,allowBlank : false
		,style:'margin:0px'
	});
	
	var enabled = new Ext.form.Checkbox({
		name : 'usuario.enabled'
		,value : '<s:message text="${usuario.enabled}" javaScriptEscape="true" />'
		,fieldLabel : 'enabled'
	});
	

	var authorities = new Ext.ux.Multiselect({
		name : 'authorities'
		,fieldLabel : '<s:message code="admin.user.authorities" />'
		,data : <json:array items="${usuario.authorities}" var="a" >
		  <json:array items="${a.authority}" />
		</json:array>
		,dataFields : ['rol']
		,displayField : 'rol'
		,valueField : 'rol'
		,legend : 'roles'
		,width : 150
	});

	var gridAuthReader = new Ext.data.ArrayReader({},
		[ 
			{name : 'rol'} 
		]
	);
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	
	var gridAuthData = <json:array items="${usuario.authorities}" var="a" >
		  <json:array items="${a.authority}" />
		</json:array>;
	var gridAuth = new Ext.grid.GridPanel({
		store : new Ext.data.Store({
			reader:gridAuthReader
			,data : gridAuthData})
		,
		cm : new Ext.grid.ColumnModel([
			sm
			,{header : 'Rol', dataIndex : 'rol'}
		])
		,sm:sm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,height : 200
		,title : 'Roles'
		,id:'gr'
	});
	
	var getAuthorities = function(){
		var values = [];
		var selected=gridAuth.getSelections();
		for(var i=0;i < selected.length;i++){
			values.push(selected[i].get('rol'));
		}
		return values;
	}

//--- fin de los campos
	
	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		//,formbind : true
		,bindform : true
		,handler : function(){
			page.submit({
				flow : 'admin/editUsuario'
				,eventName : 'update'
				,formPanel : formUser
			});
		}
	});
	
	var btnGuardar2 = new Ext.Button({
		text : 'Guardar y cerrar'
		,handler : function(){
			page.submit({
				//flow : 'admin/editUsuario'
				eventName : 'updateClose'
				,formPanel : formUser
				,success : function(){ page.fireEvent('done') }
			});
		}
	});
	
	
	var btnBorrar = new Ext.Button({
		text : '<s:message code="admin.user.borrar" text="**Borrar" />'
		,handler : function(){
			page.webflow({
				flow :'admin/editUsuario'
				,eventName : 'delete'
				,params : {id : formUser.getForm().findField('usuario.username').getValue()}
				,success : function(data){
					page.fireEvent('done');
				}
				,error : function(data, config){
					fwk.debug("callback de error");
				}
				,formPanel : formUser //para mostrar los errores
			});
			
		}
	});
	
	
	
	var formUser = new Ext.form.FormPanel({
		autoHeight : true
		,items : [
				{
					xtype : 'errorList'
					
				}
				,{
					xtype : 'panel'
					,border : false
					,layout : 'column'
					,items : [
						{ xtype : 'fieldset'
					 	 ,autoHeight : true
						  ,columnWidth : 0.5
						  ,border: false
						  ,items : [ username, apellido1, apellido2, authorities, enabled ]
						}
						,{ xtype : 'fieldset'
				  		  ,autoHeight : true
						  ,columnWidth : 0.5
						  ,border: false
						  ,items : [ login, password, alta, gridAuth  ]
					
						}
					]
				}
				]
		,bbar : [
			btnGuardar
			,btnGuardar2
			,btnBorrar
		]
		,bodyStyle : 'padding:10px'
	});
	
	//fwk.dom.addToParentContainer('${fwk.uuid}', formUser);
	//container.add( formUser);
	page.add(formUser);
	formUser.getForm().findField(0).focus(false, 10);
	
	
	
</fwk:page>