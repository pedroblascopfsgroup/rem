<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<fwk:page>

	var fechaElevacionSareb = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,value: '<fwk:date value="${sancion.fechaElevacion}" />'
		,fieldLabel : '<s:message code="expedientes.consulta.tabsancion.fecha.elevacion" text="**F. Elevación Sareb" />'
		,style:'margin:0px'
	});
	
	var fechaSancionSareb = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,value: '<fwk:date value="${sancion.fechaSancion}" />'
		,fieldLabel : '<s:message code="expedientes.consulta.tabsancion.fecha.sancion" text="**F. Sanción Sareb" />'
		,style:'margin:0px'
	});
	
	<pfsforms:textfield name="nWorkFlow"  labelKey="expedientes.consulta.tabsancion.num.workflow" label="**Nº Workflow" 
		width="100" value='${sancion.numWorkFlow}' />

	var listDecisionSancion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var decSancionStore = page.getStore({
	       flow: 'mejexpediente/getListDecisionSancion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'decisionSancion'
	    }, listDecisionSancion)	      
	});
    
    decSancionStore.webflow();
    
    var codigoDecSancion = '${sancion.decision.codigo}';
    
	var decSancion = new Ext.form.ComboBox({
		name:'decSancion'
        ,store: decSancionStore
        ,mode:'local'
        ,triggerAction:'all'
        ,editable: false
        ,fieldLabel: '<s:message code="expedientes.consulta.tabsancion.decision" text="**Decisión" />'
        ,displayField:'descripcion'
        ,valueField: 'codigo'
        ,height : 35
        ,width : 200
        ,value: '${sancion.decision.descripcion}'
    });
    
    
    decSancion.on('select', function(){
		codigoDecSancion = decSancion.getValue();
	});
	
    var labelObervaciones = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabsancion.observaciones" text="**Observaciones:"/>'
		,style:'font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var observacionesTextArea = new Ext.form.TextArea({
		name: 'observaciones'
		,value: '${sancion.observaciones}'
		,width: 350
		,height: 125
		,style:'margin-top:5px'
		,hideLabel: true
	});
	
	var getParametros = function() {
	 	var p = {};
	 	p.idExpediente = '${idExpediente}';
	 	p.id = '${sancion.id}';
	 	p.fechaElevacion = fechaElevacionSareb.getValue() ? fechaElevacionSareb.getValue().format('d/m/Y') : '';
	 	p.fechaSancion = fechaSancionSareb.getValue() ? fechaSancionSareb.getValue().format('d/m/Y') : '';
		p.decision = codigoDecSancion;
	 	p.nWorkFlow = nWorkFlow.getValue();
	 	p.observaciones = observacionesTextArea.getValue();
	    return p;
	}  
	
	var btnGuardar = new Ext.Button({
       text:  '<s:message code="app.guardar" text="**Guardar" />'
       ,iconCls : 'icon_ok'
       ,handler:function(){
			if(decSancion.getValue() == ''){
				Ext.Msg.alert('Error', '<s:message code="expedientes.consulta.tabsancion.msg.cmpTipo.required" text="**Debe indicar la decisi\u00F3n sobre la sanci\u00F3n." />');
			}else if(app.decisionSancion.CODIGO_DECISION_SANCION_APROBADA_CON_CONDICIONES == decSancion.getValue() && observacionesTextArea.getValue()==''){
				Ext.Msg.alert('Error', '<s:message code="expedientes.consulta.tabsancion.msg.validacionTipo" text="**Debe rellenar el campo de observaciones si el tipo decision es Aprobado con condiciones." />');
			}else{	
				var flow = 'mejexpediente/guardaSancionExpediente';
	      		var p = getParametros();
	      		page.webflow({
	      			flow:flow
	      			,params: p
	      			,success: function(){
            		   page.fireEvent(app.event.DONE);
	            	}
	      		});
			}
     	}
    });
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	
	var panelEdicion = new Ext.form.FormPanel({
		bodyStyle : 'padding:10px'
		,autoHeight : true
		,items : [{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[<sec:authorize ifAllGranted="PERSONALIZACION-HY">fechaElevacionSareb, fechaSancionSareb, nWorkFlow, </sec:authorize> decSancion, labelObervaciones, observacionesTextArea]
					}
				]
			}
		]
		,bbar : [btnGuardar, btnCancelar]
	});
	

	page.add(panelEdicion);

</fwk:page>
