<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var labelStyle='font-weight:bolder;width:150';
	var fecha=new Ext.ux.form.XDateField({
		fieldLabel:'**Fecha'
		,name:'fecha'
		,labelStyle:labelStyle
		,value: new Date()
	});
	var solicitante = app.creaText('solicitante','<s:message code="acuerdos.solicitante" text="**Solicitante" />','Usuario|Entidad',{labelStyle: labelStyle});
	var dictTipoAcuerdo = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsTipoAcuerdoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoAcuerdo
	});
	
	var comboTipoAcuerdo = new Ext.form.ComboBox({
				store:optionsTipoAcuerdoStore
				,displayField:'descripcion'
				,editable:false
				,name:'tipoAcuerdo'
				,labelStyle:labelStyle
				,valueField:'codigo'
				,mode: 'local'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdos.tipoacuerdo" text="**Tipo Acuerdo" />'
	});
	var dictAceptacion = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsAceptacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictAceptacion
	});
	
	var comboAceptacion = new Ext.form.ComboBox({
				store:optionsAceptacionStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,name:'aceptacion'
				,labelStyle:labelStyle
				,editable:false
				,mode: 'local'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdos.aceptacion" text="**Aceptacion" />'
	});
	
	var fechaAceptacion =new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdos.fecha" text="**Fecha" />'
		,name:'fechaAceptacion'
		,labelStyle:labelStyle
		,value: new Date()
	});
	
	var dictTipoPago = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsTipoPagoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoPago
	});
	
	var comboTipoPago = new Ext.form.ComboBox({
				store:optionsTipoPagoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,name:'tipoPago'
				,editable:false
				,labelStyle:labelStyle
				,mode: 'local'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdos.tipopago" text="**Tipo Pago" />'
	});
	var importe = app.creaNumber('importe','<s:message code="acuerdos.importepago" text="**Importe" />','1',{labelStyle:labelStyle,pepe:'ola'});
	var importe = new Ext.form.NumberField({
		name:'importe'
		,fieldLabel:'<s:message code="acuerdos.importepago" text="**Importe" />'
	})
	var dictPeriodicidad = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsPeriodicidadStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictPeriodicidad
	});
	
	var comboPeriodicidad = new Ext.form.ComboBox({
				store:optionsPeriodicidadStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,name:'periodicidad'
				,editable:false
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="acuerdos.periodicidad" text="**Periodicidad" />'
	});
	// simple array store
	var data = [
		['1', 'dias'],
        ['2', 'semanas'],
        ['3', 'meses'],
        ['4', 'años']
	];
    var store = new Ext.data.SimpleStore({
        fields: ['codigo', 'descripcion']
        ,data : data
    });
    var combo = new Ext.form.ComboBox({
        store: store,
        displayField:'descripcion',
		//fieldLabel:'<s:message code="" text="**Unidad Periodicidad" />',
		labelStyle:labelStyle,
        typeAhead: true,
		labelSeparator:'',
        mode: 'local',
		width:70,
        forceSelection: true,
		editable:false,
        triggerAction: 'all',
        selectOnFocus:true
    });
	var labelDias = new Ext.form.Label({
		text:'<s:message code="acuerdos.periodopago" text="**Periodo" />'+':' 
		,style:labelStyle
		,cls:'x-form-item'
	});
	var dias = app.creaNumber('dias','<s:message code="acuerdos.periodopago" text="**Periodo" />' ,'10',{labelStyle:labelStyle});
	var fsDias=new Ext.form.FieldSet({
		border:false
		,items:[
			{
				layout:'column'
				,viewConfig:{columns:2}
				,title:'Periodo'
				,defaults:{xtype:'fieldset'}
				,items:[dias,combo]
			}
		]
	});
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdos.observaciones" text="**Observaciones" />'
		,value:'observaciones del acuerdo'
		,width:640
		,name:'observaciones'
		,labelStyle:labelStyle
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
	var fase2=
		{
			text:'Fase 2'
			,menu:[
				{
					text:'Embargo Bienes'
					,iconCls:'icon_embargo_bienes'
					,handler : function(){ 
						app.openTab("Embargo Bienes","fase2/embargoBienes",{},{iconCls:'icon_embargo_bienes'})
					}	 
				}
				,{
					text:'Interrupcion por recurso'
					,handler : function(){ 
						app.openTab("Interrupcion por Recurso","fase2/interrupcionRecurso")
					}
				}
				,{
					text:'Propuestas de Acuerdo'
					,iconCls:'icon_acuerdo'
					,handler : function(){ 
						app.openTab("Propuestas de Acuerdo","fase2/propuestasAcuerdo",{},{iconCls:'icon_acuerdo'})
					}
				}
				,{
					text:'Consulta de Asunto'
					,iconCls : 'icon_asuntos'
					,handler : function(){ 
						app.openTab("Asunto","fase2/consultaAsunto",{},{iconCls : 'icon_asuntos'})
					}
				}
				,{
					text:'Consulta de Procedimiento'
					,iconCls:'icon_procedimiento'
					,handler : function(){ 
						app.openTab("Procedimiento","fase2/consultaProcedimiento",{},{iconCls:'icon_procedimiento'})
					}
				}
				,{
					text:'Gestor'
					,iconCls:'icon_usuario'
					,handler : function(){ 
						app.openTab("Gestor","fase2/consultaGestor",{},{iconCls:'icon_usuario'})
					}
				}
			]
			
		};
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[fecha, solicitante,comboTipoAcuerdo, comboAceptacion , fechaAceptacion  ]
						//,columnWidth:.5
						,border:false
						,width:330
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						//,columnWidth:.5
						,width:400
						,items:[ comboTipoPago,importe, comboPeriodicidad,app.creaPanelHz({},[labelDias,dias,combo])]
					}
				]
			}
			,{
				border : false
				,bodyStyle:'padding:5px;'
				,layout : 'column'
				,viewConfig : { columns : 1 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false ,width:800}
				,items:[{items:observaciones}]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});

	page.add(panelEdicion);
</fwk:page>