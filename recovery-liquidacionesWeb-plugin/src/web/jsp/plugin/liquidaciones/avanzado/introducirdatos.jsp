<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	var labelStyle='font-weight:bolder;width:100';
	
	<pfs:hidden name="idAsunto" value="${idAsunto}" />
	<pfs:hidden name="isEdit" value="${isEdit}" />
	
	<pfs:hidden name="anteriorContrato" value="${dtoCalculoLiquidacion.contrato}" />
	<pfs:hidden name="anteriorFechaCierre" value="${dtoCalculoLiquidacion.fechaCierre}" />
	<pfs:hidden name="anteriorFechaLiquidacion" value="${dtoCalculoLiquidacion.fechaLiquidacion}" />
	
	<%-- Como no se quiere utilizar el estado calculo, de momento, le pasamos siempre como pendiente --%>
	<pfs:hidden name="estadoCalculo" value='PTE' />
	
	var actuacionesAsunto = {"actuaciones" :<json:array name="actuaciones" items="${actuaciones}" var="a">
		<json:object>
			<json:property name="id" value="${a.id}" />
			<json:property name="nombre" value="${a.nombreProcedimiento}" />
		</json:object>
	</json:array>};

	<pfsforms:combo name="actuaciones"
		 dict="actuacionesAsunto" 
		 labelKey="plugin.liquidaciones.introducirdatos.control.actuaciones"
		 displayField="nombre" root="actuaciones" label="**Actuaciones" 
		 value="" valueField="id" width="500" obligatory="false"/>
	
	actuaciones.setVisible(false);
	<pfs:defineParameters name="pcontratos" paramId=""
		idAsunto="idAsunto"
	/>
	
	<pfsforms:remotecombo 
		name="contratos" 
		dataFlow="plugin.liquidaciones.contratosData" 
		labelKey="plugin.liquidaciones.introducirdatos.control.contratos" 
		displayField="codigo" 
		root="contratos" 
		label="**Contratos" 
		value="" 
		valueField="id"
		parameters="pcontratos"
		width="500"
		obligatory="true"
		/>
		contratos.editable=false;
	
	<pfsforms:textfield name="nombrePersona" labelKey="plugin.liquidaciones.introducirdatos.control.nombre" label="**Nombre" value="" obligatory="true" width="500"/>
	<pfsforms:textfield name="dni" labelKey="plugin.liquidaciones.introducirdatos.control.dni" label="**D.N.I." value="" obligatory="true"/>
	
	contratos_Store.on('load',function (){
		if(isEdit.getValue()){
			contratos.setValue("${dtoCalculoLiquidacion.contrato}");
		}	
	});
	
	contratos.reload(true);	 
	
	<%--	 
	actuaciones.on('select',function (){
		contratos.reload(true);	 
	});
	 --%>
	contratos.on('select',function (){
		Ext.Ajax.request({
			url: page.resolveUrl('plugin.liquidaciones.avanzado.getliquidacion')
			,params: {id: contratos.getValue(), idAsunto: idAsunto.getValue()}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				if (r.persona != undefined) {
					nombrePersona.setValue(r.persona.nombre);
					dni.setValue(r.persona.docid);
				}
				if (r.liquidacion != undefined) {
					capital.setValue(r.liquidacion.capital);
					interesesOrdinarios.setValue(r.liquidacion.interesesOrdinarios);
					interesesDemora.setValue(r.liquidacion.interesesDemora);
					comisiones.setValue(r.liquidacion.comisiones);
					impuestos.setValue(r.liquidacion.impuestos);
					gastos.setValue(r.liquidacion.gastos);
					fechaCierre.setValue(r.liquidacion.fechaCierre);
				}
				if (r.contrato != undefined) {
					fechaVencimiento.setValue(r.contrato.fechaVencimiento);
					tipoInteres.setValue(r.contrato.tipoInteres);
				}
		}});
	});
	
	<pfs:defineParameters name="parametros" paramId=""
		asunto="idAsunto"
		actuacion="actuaciones"
		contrato="contratos"
		nombrePersona="nombrePersona"
		documentoId="dni"
		
		capital="capital"
		interesesOrdinarios="interesesOrdinarios"
		interesesDemora="interesesDemora"
		comisiones="comisiones"
		gastos="gastos"
		impuestos="impuestos"
		fechaCierre="fechaCierre"
	
		costasLetrado="costasLetrado"
		costasProcurador="costasProcurador"
		otrosGastos="otrosGastos"
	
		baseCalculo="baseCalculo"
		fechaLiquidacion="fechaDeLiquidacion"
		tipoMoraCierre="tipoDemoraCierre"
		nombre="nombre"
		
		estadoCalculo="estadoCalculo"
	/>
	
	<%-- tiposInteres="tiposInteresStore" --%>

	<pfs:buttoncancel name="btCancelar"/>
	
	<pfs:button name="btAceptar" caption="**Aceptar"  captioneKey="plugin.liquidaciones.introducirdatos.action.aceptar" iconCls="icon_ok">
		if (tipoDemoraCierre.value > 100) {
			Ext.Msg.alert('<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Generar liquidaci�n" />','<s:message code="plugin.liquidaciones.introducirdatos.message.tipoDemoraCierre" text="**El valor del Tipo Demora al Cierre no puede ser superior al 100%" />');		
		} 
		else {
		   	if( fechaCierre.getValue() > fechaDeLiquidacion.getValue()){
				Ext.MessageBox.alert('Error','<s:message code="plugin.liquidaciones.introducirdatos.fechaCierreMayorfechaLiquidacion" text="**La Fecha de Cierre no puede ser posterior a la Fecha de Liquidaci�n" />');
				return false;
			} else {		
				if (validarForm()) {
					if(isEdit.getValue() && (anteriorContrato.getValue()!=contratos.getValue() || anteriorFechaCierre.getValue()!=fechaCierre.getValue().format("d/m/Y") ||  anteriorFechaLiquidacion.getValue()!=fechaDeLiquidacion.getValue().format("d/m/Y"))){
						Ext.Msg.alert('<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Generar liquidaci�n" />','<s:message code="plugin.liquidaciones.introducirdatos.datos.modificados" text="**No es posible guardar los datos si se ha modificado el contrato, la fecha de cierre o la fecha de liquidaci�n" />');
					}else{
						
						fechaCierre.setValue(fechaCierre.getValue().format("d/m/Y"));	
						
						var p=parametros();
						
						var storeList = tiposInteresStore.data.items;
						if (storeList.length > 0) {
							var tiposInteresesData = [];
							
							var i;
							for (i=0;i < storeList.length;i++) {
								var reg = storeList[i].data;
								var tipo = '';
								tipo = reg.fecha + '#' + reg.tipoInteres;
								tiposInteresesData.push(tipo);
							}
						}
						
						p.tiposIntereses = tiposInteresesData;
						
						if(isEdit.getValue()){
							p.id = "${dtoCalculoLiquidacion.id}";
						}
						
						page.webflow({
			      			flow:'liquidaciones/guardaCalculoLiquidacion'
			      			,params: p
			      			,success: function(){
								page.fireEvent(app.event.DONE);
			           		}	
				      	});
				      	
					}
				} else {
					Ext.Msg.alert('<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Generar liquidaci�n" />','<s:message code="plugin.liquidaciones.introducirdatos.message.obligatorios" text="**Debe rellenar todos los campos obligatorios" />');
				}
			}	
		}
	</pfs:button>


	<pfsforms:numberfield name="capital" labelKey="plugin.liquidaciones.introducirdatos.control.capital" label="**Capital" value="" obligatory="true" allowDecimals="true"/>
	<pfsforms:numberfield name="interesesOrdinarios" labelKey="plugin.liquidaciones.introducirdatos.control.interesesOrdinarios" label="**Intereses Ordinarios" value="" obligatory="false" allowDecimals="true"/>
	<pfsforms:numberfield name="interesesDemora" labelKey="plugin.liquidaciones.introducirdatos.control.interesesDemora" label="**Intereses Demora" value="" obligatory="false" allowDecimals="true"/>
	<pfsforms:numberfield name="comisiones" labelKey="plugin.liquidaciones.introducirdatos.control.comisiones" label="**Comisiones" value="" allowDecimals="true"/>
	<pfsforms:numberfield name="gastos" labelKey="plugin.liquidaciones.introducirdatos.control.gastos" label="**Gastos" value="" allowDecimals="true"/>
	<pfsforms:numberfield name="impuestos" labelKey="plugin.liquidaciones.introducirdatos.control.impuestos" label="**Impuestos" value="" allowDecimals="true"/>
	<pfs:hidden name="tipoInteres" value="" />
	<pfs:hidden name="fechaVencimiento" value="" />
	<pfsforms:datefield name="fechaCierre" labelKey="plugin.liquidaciones.introducirdatos.control.fechaCierre" label="**Fecha Cierre" obligatory="true"/>
	fechaCierre.on('render', function() {this.validate();});

	<pfsforms:fieldset name="fieldDatosCierre" caption="**Datos Cierre" captioneKey="plugin.liquidaciones.introducirdatos.datoscierre" border="true" width="280" height="260"
		items="capital,interesesOrdinarios,interesesDemora,comisiones,gastos,impuestos,tipoInteres,fechaCierre" />
		
	<pfsforms:numberfield name="costasLetrado" labelKey="plugin.liquidaciones.introducirdatos.control.costasLetrado" label="**Costas Letrado" value="" obligatory="false" allowDecimals="true"/>
	<pfsforms:numberfield name="costasProcurador" labelKey="plugin.liquidaciones.introducirdatos.control.costasProcurador" label="**Costas Procurador" value="" obligatory="false" allowDecimals="true"/>
	<pfsforms:numberfield name="otrosGastos" labelKey="plugin.liquidaciones.introducirdatos.control.otrosGastos" label="**Otros Gastos" value="" obligatory="false" allowDecimals="true"/>
		
	<pfsforms:fieldset name="fieldOtrosGastos" caption="**Datos Cierre" captioneKey="plugin.liquidaciones.introducirdatos.control.otrosGastos" border="true" width="280" height="260"
		items="costasLetrado,costasProcurador,otrosGastos" />
	
	<%--<pfsforms:numberfield name="baseCalculo" labelKey="plugin.liquidaciones.introducirdatos.control.baseCalculo" label="**Base de C�lculo" value="" obligatory="true" allowDecimals="true"/>  --%>
	var arrayValores = [{"id":'360',"value":'360'},{"id":'365',"value":'365'}];
	<pfsforms:combo name="baseCalculo" root="" displayField="id" valueField="value" label="**Base de C�lculo" labelKey="plugin.liquidaciones.introducirdatos.control.baseCalculo"
		value="360" dict="arrayValores" obligatory="true" width="133" forceSelection="true" />
	baseCalculo.setEditable('false');
	<pfsforms:datefield name="fechaDeLiquidacion" labelKey="plugin.liquidaciones.introducirdatos.control.fechaLiquidacion" label="**Fecha de liquidaci�n" obligatory="true" />
	fechaDeLiquidacion.on('render', function() {this.validate();});
	fechaDeLiquidacion.setValue(new Date());
	<pfsforms:numberfield name="tipoDemoraCierre" labelKey="plugin.liquidaciones.introducirdatos.control.tipoDemoraCierre" label="**Tipo Demora al Cierre" value="" 
		obligatory="true" allowDecimals="true" allowNegative="false" />
	
	<pfsforms:textfield name="nombre" labelKey="plugin.liquidaciones.introducirdatos.control.nombre" label="**Nombre" value="" obligatory="true" width="150"/>

	<pfsforms:fieldset name="fieldParametrosLiquidacion" caption="**Par�metros Liquidaci�n" captioneKey="plugin.liquidaciones.introducirdatos.control.parametrosLiquidacion" border="true" width="280" height="260"
		items="baseCalculo,fechaDeLiquidacion,tipoDemoraCierre,nombre" />

	var fieldImportes = new Ext.Panel({
		autoHeight : true
		,autoWidth : true
		,bodyStyle:'padding-left:5px;cellspacing:5px;'
		,border : false
		,items : [
			{   autoHeight:true
				,layout:'table'
				,columns: 3
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items : [{items:[fieldDatosCierre]},{items:[fieldOtrosGastos]},{items:[fieldParametrosLiquidacion]}]
			}
		]
	});	
	
	var tiposInteresStore = new Ext.data.JsonStore({
	        fields: ['fecha', 'tipoInteres']
			,sortInfo: {
			    field: 'fecha',
			    direction: 'ASC' // or 'DESC' (case sensitive for local sorting)
			}	       
	});
		
	<pfs:defineColumnModel name="tiposInteresCM">
		<pfs:defineHeader dataIndex="fecha" captionKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.fecha" caption="**Fecha" sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="tipoInteres" captionKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.tipoInteres" caption="**Tipo de inter�s" sortable="true" /> 
	</pfs:defineColumnModel>
	
	var validarFormNewTipoInteres = function() {
		if (!newFecha.isValid())
			return false;
			
		if (!newTipoInteres.isValid())
			return false;
		
		return true;
	};
	
	<pfs:button name="btnOkTipoInteres" captioneKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.agregar" caption="**Agregar" iconCls="icon_mas">
		if (newTipoInteres.value > 100) {
			Ext.Msg.alert('<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Generar liquidaci�n" />','<s:message code="plugin.liquidaciones.introducirdatos.message.nuevoTipoInteres" text="**El nuevo tipo de inter�s no puede ser superior al 100%" />');
		} else {
			if (validarFormNewTipoInteres()) {
			    var newTipoInteresRecord = tiposInteresStore.recordType;
		   		var t = new newTipoInteresRecord({
		   			fecha: newFecha.value,
		   			tipoInteres: newTipoInteres.value
		   		});
				tiposInteresStore.insert(0,t);			
				
	
				wNewTipoInteres.hide();
				
				newFecha.reset();
				newTipoInteres.reset();
			} else {
				Ext.Msg.alert('<s:message code="plugin.liquidaciones.introducirdatos.window.title" text="**Generar liquidaci�n" />','<s:message code="plugin.liquidaciones.introducirdatos.message.obligatorios" text="**Debe rellenar todos los campos obligatorios" />');
			}
		}
	</pfs:button>
	
	<pfs:button name="btnCancelTipoInteres" captioneKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.cancelar" caption="**Cancelar" iconCls="icon_cancel">
		wNewTipoInteres.hide();
	</pfs:button>	
		
	<pfsforms:numberfield name="newTipoInteres" labelKey="plugin.liquidaciones.introducirdatos.control.newTipoInteres.tipoInteres" label="**Nuevo tipo inter�s" value="" 
		obligatory="true" allowDecimals="true" allowNegative="false" />
	<pfsforms:datefield name="newFecha" labelKey="plugin.liquidaciones.introducirdatos.control.newTipoInteres.Fecha" label="**Fecha" obligatory="true" />
	newFecha.on('render', function() {this.validate();});
	<pfsforms:fieldset name="fieldNewTipoInteres" caption="" captioneKey="" border="false" width="300"
		items="newTipoInteres,newFecha" />
	
	var panelNewTipoInteres = new Ext.Panel({
		layour:'card'
		,bodyStyle:'padding:10px'
		,layoutConfig: {deferredRender : true}
		,border : false
		,activeItem: 0
		,autoHeight: true
		,tbar: [btnOkTipoInteres,btnCancelTipoInteres]
		,items: [fieldNewTipoInteres]
	});
	
	var wNewTipoInteres = new Ext.Window({
		width: 330
		,closable: false
		,title: '<s:message code="plugin.liquidaciones.introducirdatos.control.newTipoInteres.title" text="**Actualizaci�n de tipos de inter�s" />'
		,modal: true
		,items: [panelNewTipoInteres]
	});
		
	<pfs:button name="btnAddTipoInteres" captioneKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.agregar" caption="**A�adir" iconCls="icon_mas">
		wNewTipoInteres.show();
	</pfs:button>
		
	<pfs:button name="btnDelTipoInteres" captioneKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres.borrar" caption="**Borrar" iconCls="icon_menos">
		if (gridTiposInteres.getSelectionModel().getCount()>0){
			Ext.Msg.confirm('Borrar', '�Esta seguro de eliminar este elemento?', function(btn){
				if (btn == 'yes'){
	            	var sel=gridTiposInteres.getSelectionModel().getSelected();
	            	tiposInteresStore.remove(sel);
	            }
			});
		};
	</pfs:button>
		
	
	<pfsforms:gridpanel name="gridTiposInteres" store="tiposInteresStore" columnModel="tiposInteresCM" width="500" bbar="[btnAddTipoInteres,btnDelTipoInteres]"
		title="**Actualizaci�n de tipos de inter�s" titleKey="plugin.liquidaciones.introducirdatos.control.gridTiposInteres" />
 
 	
 	gridTiposInteres.on('render', function() {
 		if(isEdit.getValue()){
 		
 			var strTipsInt = '${dtoCalculoLiquidacion.tiposIntereses}'; 
 			
 			if(strTipsInt.length > 0){
 				var tiposInteres = strTipsInt.substring(1,strTipsInt.length - 1).split(',');
	 			var newTipoInteresRecord = tiposInteresStore.recordType;
	 			
	 			for(i=0;i < tiposInteres.length; i++){
	 				
	 				var partesTipInt = tiposInteres[i].split('#');
	 				var f = new Date(partesTipInt[0]);
	 				var ti = parseFloat(partesTipInt[1]);
	 			
	 				var t = new newTipoInteresRecord({
		   				fecha: convertDate(f),
		   				tipoInteres: ti
		   			});
					tiposInteresStore.insert(0,t);
	 			}
 			}
 		}
 	});
 	
 	function convertDate(inputFormat) {
	  function pad(s) { return (s < 10) ? '0' + s : s; }
	  var d = new Date(inputFormat);
	  return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join('/');
	}
 
 
	//LabelStyle
	actuaciones.labelStyle=labelStyle;
	contratos.labelStyle=labelStyle;
	nombre.labelStyle=labelStyle;
	nombrePersona.labelStyle=labelStyle;
	dni.labelStyle=labelStyle;
	
	capital.labelStyle=labelStyle;
	interesesOrdinarios.labelStyle=labelStyle;
	interesesDemora.labelStyle=labelStyle;
	comisiones.labelStyle=labelStyle;
	gastos.labelStyle=labelStyle;
	impuestos.labelStyle=labelStyle;
	fechaCierre.labelStyle=labelStyle;
	
	costasLetrado.labelStyle=labelStyle;
	costasProcurador.labelStyle=labelStyle;
	otrosGastos.labelStyle=labelStyle;
	
	baseCalculo.labelStyle=labelStyle;
	fechaDeLiquidacion.labelStyle=labelStyle;
	tipoDemoraCierre.labelStyle=labelStyle;

	var panelEdicion = new Ext.FormPanel({
		//autoHeight : true
		height: 500
		,autoScroll : true
		,autoWidth : true
		,standardSubmit: true
		,url: 'liquidaciones/openReport'
		,bodyStyle:'padding:5px;cellspacing:5px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,columns: 1
				,border:false
				,bodyStyle:'padding:5px;cellspacing:5px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [actuaciones,contratos,nombrePersona,dni,fieldImportes,gridTiposInteres]}
				]
			}
		]
		,bbar : [
			btAceptar, btCancelar
		]
	});	
	page.add(panelEdicion);
	
	
	var rellenarCampos = function(){
		actuaciones.setValue("${dtoCalculoLiquidacion.actuacion}");
		contratos.reload(true);
		nombrePersona.setValue("${dtoCalculoLiquidacion.nombrePersona}");
		dni.setValue("${dtoCalculoLiquidacion.documentoId}");
		capital.setValue("${dtoCalculoLiquidacion.capital}");
		interesesOrdinarios.setValue("${dtoCalculoLiquidacion.interesesOrdinarios}");
		interesesDemora.setValue("${dtoCalculoLiquidacion.interesesDemora}");
		comisiones.setValue("${dtoCalculoLiquidacion.comisiones}");
		gastos.setValue("${dtoCalculoLiquidacion.gastos}");
		impuestos.setValue("${dtoCalculoLiquidacion.impuestos}");
		fechaCierre.setValue("${dtoCalculoLiquidacion.fechaCierre}");
		costasLetrado.setValue("${dtoCalculoLiquidacion.costasLetrado}");
		costasProcurador.setValue("${dtoCalculoLiquidacion.costasProcurador}");
		otrosGastos.setValue("${dtoCalculoLiquidacion.otrosGastos}");
		baseCalculo.setValue("${dtoCalculoLiquidacion.baseCalculo}");
		fechaDeLiquidacion.setValue("${dtoCalculoLiquidacion.fechaLiquidacion}");
		tipoDemoraCierre.setValue("${dtoCalculoLiquidacion.tipoMoraCierre}");
		nombre.setValue("${dtoCalculoLiquidacion.nombre}");
	}
	
	var validarForm = function() {
		if (!actuaciones.isValid())
			return false;
		
		if (!contratos.isValid())
			return false;
		
		if(!nombrePersona.isValid())
			return false;
			
		if (!dni.isValid())
			return false;
			
		if (!capital.isValid())
			return false;
			
		if (!interesesOrdinarios.isValid())
			return false;
			
		if (!interesesDemora.isValid())
			return false;
			
		if (!comisiones.isValid())
			return false;
			
		if (!gastos.isValid())
			return false;
			
		if (!impuestos.isValid())
			return false;
			
		if (!fechaCierre.isValid())
			return false;
			
		if (!costasLetrado.isValid())
			return false;
			
		if (!costasProcurador.isValid())
			return false;
			
		if (!otrosGastos.isValid())
			return false;
			
		if (!baseCalculo.isValid())
			return false;
		
		if (!fechaDeLiquidacion.isValid())
			return false;
			
		if (!tipoDemoraCierre.isValid())
			return false;
			
		if (!nombre.isValid())
			return false;
						
		return true;
	}		
	
	if(isEdit.getValue()){
		rellenarCampos();
	}
	
	


</fwk:page>