<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<fwk:page>
	var width=200;
	var style='text-align:left;font-weight:bolder;width:100';
	
	var titulocomentario = new Ext.form.Label({
   	text:'<s:message code="analisisPersona.comentario" text="**Comentario"/>'
	,style:'font-weight:bolder; font-size:11'
	}); 
	var comentario=new Ext.form.TextArea({
		fieldLabel:'<s:message code="analisisPersona.comentario" text="**Comentario"/>'
		,width:620
		,height: 200
		,hideLabel:true
		,labelStyle:style
		,name:'comentario'
		,maxLength: 250
		<c:if test="${analisisPO.comentario!=null}">
			,value : '<s:message text="${analisisPO.comentario}" javaScriptEscape="true" />'
		</c:if>
		<c:if test="${analisisPO.comentario==null}">
			,value : ''
		</c:if>
		,blankText: 'Campo requerido'
	});

	var idApp = new Ext.form.Hidden({name:'idAnalisisOperacion', value :'${analisisPO.id}'});
	var idContrato = new Ext.form.Hidden({name:'idContrato', value :'${analisisPO.contrato.id}'});
	var idPersona = new Ext.form.Hidden({name:'idPersona', value :'${idPersona}'});

	var validar = function(){
		if (comentario.getValue()==null || comentario.getValue().trim() === ''){
			return false;
		}
		if (comboValoraciones.getValue() == null || comboValoraciones.getValue()===''){
			return false;
		}
		if (comboImpacto.getValue() == null || comboImpacto.getValue()===''){
			return false;
		}
		return true;
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (validar()){
				page.submit({
					 eventName : 'update'
					,formPanel : panelEdicion
					,success : function(){page.fireEvent(app.event.DONE) }
				});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisisPersonas.faltanCampos" text="**Debe completar todos los campos"/>')
			}
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var comboValoraciones = app.creaCombo({
		data : <app:dict value="${valoraciones}"/>
		,allowBlank:false
		,name : 'codigoValoracion'
		,fieldLabel : '<s:message code="analisisPersona.valoraciones" text="**Tipo Valoración" />'
		,labelStyle:style
		<c:if test="${analisisPO.valoracion!=null}">
			,value : '${analisisPO.valoracion.codigo}'
		</c:if>
		<c:if test="${analisisPO.valoracion==null}">
			,value : ''
		</c:if>		
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});

	var contratoLabel = app.creaLabel('<s:message code="analisisOperaciones.contrato" text="**Contrato"/>','${analisisPO.contrato.nroContrato}');
	var tipoContrato = app.creaLabel('<s:message code="analisisOperaciones.tipoProducto" text="**Tipo Producto"/>','${analisisPO.contrato.tipoProducto.descripcion}');
	
	var comboImpacto = app.creaCombo({
		data : <app:dict value="${impactos}"/>
		,allowBlank:false
		,name : 'codigoImpacto'
		,fieldLabel : '<s:message code="analisisPersonas.impactos" text="**Tipo Impacto"/>'
		,labelStyle:style
		<c:if test="${analisisPO.impacto!=null}">
			,value : '${analisisPO.impacto.codigo}'
		</c:if>
		<c:if test="${analisisPO.impacto==null}">
			,value : ''
		</c:if>		
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		border:true
		,autoHeight:true
		,bodyStyle : 'padding:10px'
	,items:[{
				layout : 'table'
				,layoutConfig:{columns:2}
				,border : false
				
				,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop'}
				,items:[
						{ items : contratoLabel }
						,{ items :comboValoraciones  }
						,{ items : tipoContrato}
						,{ items : comboImpacto }
						,{items:titulocomentario,colspan:2}
						,{items:comentario,colspan:2}
						,idApp
						,idContrato
						,idPersona

                    
                  ]
			}
          ]
		,bbar:[btnGuardar,btnCancelar]
	});	
	page.add(panelEdicion);

</fwk:page>
