<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<fwk:page>

	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	//var labelStyleDescripcion = 'width:185x;height:60px;font-weight:bolder",width:700';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	
	var arrayCampos = new Array();
	
	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder"};
	var idAsunto = '${asunto.id}';
	var idTermino = '${termino.id}';
    var tipoAcu = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		,{name:'codigo'}
	]);
	
	var optionsAcuerdosStore = page.getStore({
	       flow: 'mejacuerdo/getListTipoAcuerdosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoAcuerdos'
	    }, tipoAcu)	       
	});	

	var comboTipoAcuerdo = new Ext.form.ComboBox({
		store:optionsAcuerdosStore
		,id:'comboTipoAcuerdo'
		,allowBlank:false
		,displayField:'descripcion'
		,valueField:'id'
		,codigo: 'codigo'
		,mode: 'remote'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.tipoAcuerdo" text="**Tipo acuerdo" />'
		,labelStyle: 'width:150px'
		,width: 150		
	});
	
	comboTipoAcuerdo.on('select', function() {
	    
	    creaCamposDynamics(this);
	    
    });
    
<!--     var creaCamposDynamics = function (cmp) { -->
    	
<!--     	var cmpLft = Ext.getCmp('dinamicElementsLeft'); -->
<!-- 	   	if (cmpLft) { -->
<!-- 	     	detalleFieldSet.remove(cmpLft, true); -->
<!-- 	   	} -->
	   	
<!-- 	  	var cmpRgt = Ext.getCmp('dinamicElementsRight'); -->
<!-- 	   	if (cmpRgt) { -->
<!-- 	     	detalleFieldSet.remove(cmpRgt, true);  -->
<!-- 	   	} -->
	   	
<!-- 	   	var v = cmp.getValue(); -->
<!--     	var r = cmp.findRecord(cmp.valueField || cmp.displayField, v); -->
    
<!-- 	    var campos = arrayCampos[r.data.codigo]; -->
	    
<!-- 	    if(typeof(campos) != "undefined"){ -->
	    
<!-- 	        var dinamicElementsLeft = []; -->
<!-- 	    	var dinamicElementsRight = []; -->
	    	
<!-- 	    	for(var i=0;i < campos.length;i++){ -->
	    		
<!-- 	    		var campo=campos[i]; -->
	    		
<!-- 	    		if (i%2 == 0) -->
<!-- 	    			dinamicElementsLeft.push(campo); -->
<!-- 	    		else -->
<!-- 	    			dinamicElementsRight.push(campo); -->
<!-- 	    	} -->
	    	
<!-- 	    	detalleFieldSet.setVisible( true ); -->
<!-- 	    	detalleFieldSetContenedor.setVisible( true ); -->
	    	
<!-- 	    	var dinamicElementsLeftSize = 400 -->
	    	
<!-- 	    	if(dinamicElementsRight.length < 1){ -->
<!-- 	    		dinamicElementsLeftSize = 800 -->
<!-- 	    	} -->
			
<!-- 			var dinamicElementsLeft2 = {id:'dinamicElementsLeft', width:dinamicElementsLeftSize,items:dinamicElementsLeft}; -->
<!-- 	    	var dinamicElementsRight2 = {id:'dinamicElementsRight', width:400,items:dinamicElementsRight}; -->

<!-- 			detalleFieldSet.add([dinamicElementsLeft2,dinamicElementsRight2]); -->
<!-- 			detalleFieldSet.doLayout(); -->
			
<!-- 	    } -->
<!-- 	}; -->
	
		
	var creaCamposDynamics = function (cmp) {
       	Ext.Ajax.request({
			url: page.resolveUrl('mejacuerdo/getCamposDinamicosTerminosPorTipoAcuerdo')
			,method: 'POST'
			,params:{idTipoAcuerdo:cmp.getValue()} 
			,success: function (result, request){
			
				var cmpLft = Ext.getCmp('dinamicElementsLeft');
			   	if (cmpLft) {
					cmpLft.el.remove();
			   	}
			   	
			  	var cmpRgt = Ext.getCmp('dinamicElementsRight');
			   	if (cmpRgt) {
					cmpRgt.el.remove();
			   	}
				
				var camposDynamics = Ext.util.JSON.decode(result.responseText);
		
				var dinamicElementsLeft = [];
				var dinamicElementsRight = [];
				
				for (var i = 0; i < camposDynamics.camposTerminoAcuerdo.length; i++) {
				    
				    var nameField = camposDynamics.camposTerminoAcuerdo[i].nombreCampo;
					var campo = arrayCampos[nameField];

				    if(typeof(campo) != "undefined"){	

			    		if (i%2 == 0)
			    			dinamicElementsLeft.push(campo);
			    		else
			    			dinamicElementsRight.push(campo);
						
				    }
				}

				detalleFieldSet.setVisible( true );
		    	detalleFieldSetContenedor.setVisible( true );
		    	
		    	var dinamicElementsLeftSize = 400
		    	
		    	if(dinamicElementsRight.length < 1){
		    		dinamicElementsLeftSize = 800
		    	}
				var dinamicElementsLeft2 = {id:'dinamicElementsLeft', width:dinamicElementsLeftSize,items:dinamicElementsLeft};
				
		    	var dinamicElementsRight2 = {id:'dinamicElementsRight', width:400,items:dinamicElementsRight};

				detalleFieldSet.add([dinamicElementsLeft2,dinamicElementsRight2]);
				detalleFieldSet.doLayout();
				
			}
			,error: function(){
			}       				
		});
	};				
	
	var optionsSubtiposAcuerdosStore = page.getStore({
	       flow: 'mejacuerdo/getListSubTiposAcuerdosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoSubtiposAcuerdos'
	    }, tipoAcu)	       
	});	
	
	var comboSubTipoAcuerdo = new Ext.form.ComboBox({
		store:optionsSubtiposAcuerdosStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'remote'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.subtipoAcuerdo" text="**Sub tipo acuerdo" />'
		,labelStyle: 'width:150px'
		,width: 150				
	});
	
arrayCampos["pagoPrevioFormalizacion"]=app.creaNumber('pagoPrevioFormalizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.agregar.detalles.importepagoprevio" text="**Importe pago previo formalizaci�n" />' , '', {id:'pagoPrevioFormalizacion'});
arrayCampos["plazosPagosPrevioFormalizacion"]=app.creaNumber('plazosPagosPrevioFormalizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Plazos pago previo formalizaci�n" />' , '', {id:'plazosPagosPrevioFormalizacion'});
arrayCampos["carencia"]=app.creaNumber('carencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.carencia" text="**Carencia" />' , '', {id:'carencia'});
arrayCampos["cuotaAsumible"]=app.creaNumber('cuotaAsumible', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cuaotaAsumible" text="**Cuota asumible cliente" />' , '', {id:'cuotaAsumible'});
arrayCampos["cargasPosteriores"]=app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', {id:'cargasPosteriores'});
arrayCampos["garantiasExtras"]=app.creaText('garantiasExtras', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.garantiasExtras" text="**Garantias extras" />' , '', {id:'garantiasExtras'});
arrayCampos["numExpediente"]=app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**N� expediente" />' , '', {id:'numExpediente'});
arrayCampos["cargasPosteriores"]=app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', {id:'cargasPosteriores'});
arrayCampos["solicitarAlquiler"]= new Ext.form.ComboBox({
	id: 'solicitarAlquiler',
	name : 'solicitarAlquiler',
	fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solicitarAlquiler" text="**Solicitar alquiler" />',
    triggerAction: 'all',
    mode: 'local',
    emptyText:'---',
    store: new Ext.data.ArrayStore({
        fields: [
            'myId',
            'displayText'
        ],
        data: [[1, 'Si'], [0, 'No']]
    }),
    valueField: 'myId',
    displayField: 'displayText'
});

arrayCampos["liquidez"]=app.creaNumber('liquidez', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.liquidezAportada" text="**Liquidez aportada" />' , '', {id:'liquidez'});
arrayCampos["tasacion"]=app.creaNumber('tasacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.tasacion" text="**Tasaci�n" />' , '', {id:'tasacion'});
arrayCampos["numExpediente"]=app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**N� expediente" />' , '', {id:'numExpediente'});
arrayCampos["importeQuita"]=app.creaNumber('importeQuita', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeApagar" text="**Importe a pagar" />' , '', {id:'importeQuita'});
arrayCampos["porcentajeQuita"]=app.creaNumber('porcentajeQuita', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.porcentajeQuita" text="** % Quita" />' , '', {id:'porcentajeQuita'});
arrayCampos["importeVencido"]=app.creaNumber('importeVencido', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeVencido" text="**Importe vencido" />' , '', {id:'importeVencido'});
arrayCampos["importeNoVencido"]=app.creaNumber('importeNoVencido', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeNoVencido" text="**Importe no vencido" />' , '', {id:'importeNoVencido'});
arrayCampos["interesesMoratorios"]=app.creaNumber('interesesMoratorios', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeInteresesMoratorios" text="**Importe intereses moratorios" />' , '', {id:'interesesMoratorios'});
arrayCampos["interesesOrdinarios"]=app.creaNumber('interesesOrdinarios', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeInteresesOrdinarios" text="**Importe intereses ordinarios" />' , '', {id:'interesesOrdinarios'});
arrayCampos["comision"]=app.creaNumber('comision', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.comisiones" text="**Comisiones" />' , '', {id:'comision'});
arrayCampos["gastos"]=app.creaNumber('gastos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.gastos" text="**Gastos" />' , '', {id:'gastos'});
arrayCampos["fechaPago"]=new Ext.form.DateField({
	id:'fechaPago'
	,name:'fechaPago'
	,value : ''
	, allowBlank : true
	,autoWidth:true
	 ,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.fechaPago" text="**Fecha pago" />'
});;
arrayCampos["nombreCesionario"]=app.creaText('nombreCesionario', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.nombreCesionario" text="**Nombre cesionario" />' , '', {id:'nombreCesionario'});
arrayCampos["relacionCesionarioTitular"]=app.creaText('relacionCesionarioTitular', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.relacionCesionarioTitular" text="**Relacion cesionario / Titular" />' , '', {id:'relacionCesionarioTitular'});
arrayCampos["solvenciaCesionario"]=app.creaNumber('solvenciaCesionario', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solvenciaCesionario" text="**Solvencia cesionario" />' , '', {id:'solvenciaCesionario'});
arrayCampos["importeCesion"]=app.creaNumber('importeCesion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeCesion" text="**Importe cesi�n" />' , '', {id:'importeCesion'});
arrayCampos["fechaPlanPago"]=new Ext.form.DateField({
	id:'fechaPlanPago'
	,name:'fechaPlanPago'
	,value : ''
	, allowBlank : true
	,autoWidth:true
	 ,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.fecha" text="**Fecha" />'
});
arrayCampos["frecuenciaPlanpago"]=app.creaNumber('frecuenciaPlanpago', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.frecuencia" text="**Frecuencia" />' , '', {id:'frecuenciaPlanpago'});
arrayCampos["numeroPagosPlanpago"]=app.creaNumber('numeroPagosPlanpago', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**N�mero pagos" />' , '', {id:'numeroPagosPlanpago'});
arrayCampos["importePlanpago"]=app.creaNumber('importePlanpago', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**Importe" />' , '', {id:'importePlanpago'});

arrayCampos["analisiSolvencia"]=new Ext.form.HtmlEditor({
		id:'analisiSolvencia'
		,name : 'analisiSolvencia'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.analisisSolvencia" text="**Analisis solvencia" />'
		,readOnly:false
		,width: 580
		,height: 200
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});	

arrayCampos["descripcionAcuerdo"]=new Ext.form.HtmlEditor({
		id:'descripcionAcuerdo'
		,name : 'descripcionAcuerdo'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.alquilerEspecial" text="**Alquiler especial" />'
		,readOnly:false
		,width: 580
		,height: 200
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});

	
<%-- 	var modoDesembolso = app.creaText('modoDesembolso', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.modoDesembolso" text="**modoDesembolso" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var formalizacion = app.creaText('formalizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.formalizacion" text="**formalizacion" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var importe = app.creaNumber('importe', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**importe" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var comisiones = app.creaNumber('comisiones', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.comisiones" text="**comisiones" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var periodoCarencia = app.creaText('periodoCarencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoCarencia" text="**periodoCarencia" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var periodicidad = app.creaText('periodicidad', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodicidad" text="**periodicidad" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var periodoFijo = app.creaText('periodoFijo', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoFijo" text="**periodoFijo" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var sistemaAmortizacion = app.creaText('sistemaAmortizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.amortizacion" text="**sistemaAmortizacion" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var interes = app.creaNumber('interes', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.interes" text="**interes" />' , '', {labelStyle:labelStyle}); --%>
<%-- 	var periodoVariable = app.creaText('periodoVariable', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoVariable" text="**periodoVariable" />' , '', {labelStyle:labelStyle}); --%>
	var informeLetrado = new Ext.form.HtmlEditor({
		id:'note'
		,readOnly:false
		,width: 600
		,height: 200
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});		
	
	var tipoPro = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTipoProductoStore = page.getStore({
	       flow: 'mejacuerdo/getListTipoProductosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoProductos'
	    }, tipoPro)	       
	});	
	
	var comboTipoProducto = new Ext.form.ComboBox({
		store:optionsTipoProductoStore
        ,displayField:'descripcion'
        ,allowBlank:false
		,valueField:'id'
		,mode: 'remote'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.producto" text="**Producto" />'
		,labelStyle: 'width:150px'
		,width: 170					
	});
	
	
	var flujoFieldSet = new Ext.FormPanel({
		autoWidth: true
		,autoHeight: true
		,style:'padding:0px'
  	   	,border:false
		,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
		 	{items:[comboTipoAcuerdo,comboSubTipoAcuerdo,comboTipoProducto],width:450}
		]
	});	
	
	var flujoFieldSetContenedor = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.titulo" text="**Flujo por soluci�n"/>' 
		,border:true
		,items: [flujoFieldSet]
	});	
	
<!-- 	var detalleFieldSet = new Ext.form.FieldSet({ -->
<%-- 		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.titulo" text="**Detalle operaciones"/>' --%>
<!-- 		,autoHeight: true -->
<!-- 		,autoWidth: true -->
<!-- 		,border:true -->
<!-- 		,style:'padding:0px' -->
<!-- 		,layout:'table' -->
<!-- 		,layoutConfig:{columns:3}	 -->
<!-- 		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375} -->
<!-- 		,items : [ -->
				
<!-- 				{ -->
<!-- 					layout:'form' -->
<!-- 					,items: [comboTipoProducto,importe,periodicidad,interes] -->
<!-- 				},{ -->
<!-- 					layout:'form' -->
<!-- 					,items: [modoDesembolso,comisiones,periodoFijo,periodoVariable] -->
<!-- 				},{ -->
<!-- 					layout:'form' -->
<!-- 					,items: [formalizacion,periodoCarencia,sistemaAmortizacion] -->
<!-- 				} -->
<!-- 			] -->
<!-- 	});	 -->

	var detalleFieldSet = new Ext.FormPanel({
		id:'dynamicForm'
		,autoHeight: false
		,autoWidth: true
		,hidden:true
		,border:false
		,style:'padding:0px'
		,layout:'column'
		,layoutConfig:{columns:2}	
		,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'}
	});	
	
	var detalleFieldSetContenedor = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.titulo" text="**Detalle operaciones"/>' 
		,hidden:true
		,items: [detalleFieldSet]
	});	
	
	var informeFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.informe" text="**Observaciones"/>'
		,layout:'form'
		,autoHeight:true
		,autoWidth: true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
			{items:[informeLetrado]}
		]
	});		
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
		
						page.fireEvent(app.event.CANCEL);  	
					}
	});	

	var btnGuardar = new Ext.Button({	
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		
       		var formulario = flujoFieldSet.getForm();
       		
       		if(formulario.isValid()){
       		
	       		var params = detalleFieldSet.getForm().getValues();
	       		
	       		Ext.apply(params, {solicitarAlquiler : Ext.getCmp('solicitarAlquiler').getValue() });
	       		Ext.apply(params, {idAcuerdo : '${idAcuerdo}' });
	       		Ext.apply(params, {idTipoAcuerdo : comboTipoAcuerdo.getValue()});
	       		Ext.apply(params, {idSubTipoAcuerdo : comboSubTipoAcuerdo.getValue()});
	       		Ext.apply(params, {idTipoProducto : comboTipoProducto.getValue()});
	       		Ext.apply(params, {informeLetrado : informeLetrado.getValue()});
	       		Ext.apply(params, {contratosIncluidos : '${contratosIncluidos}'});
	       		Ext.apply(params, {bienesIncluidos : comboBienes.getValue()});     		
	       		Ext.apply(params, {idTermino : idTermino });     		
	<!--        		Ext.apply(params, {modoDesembolso : modoDesembolso.getValue()}); -->
	<!--        		Ext.apply(params, {formalizacion : formalizacion.getValue()}); -->
	<!--        		Ext.apply(params, {importe : importe.getValue()}); -->
	<!--        		Ext.apply(params, {comisiones : comisiones.getValue()}); -->
	<!--        		Ext.apply(params, {periodoCarencia : periodoCarencia.getValue()}); -->
	<!--        		Ext.apply(params, {periodicidad : periodicidad.getValue()}); -->
	<!--        		Ext.apply(params, {periodoFijo : periodoFijo.getValue()}); -->
	<!--        		Ext.apply(params, {sistemaAmortizacion : sistemaAmortizacion.getValue()}); -->
	<!--        		Ext.apply(params, {interes : interes.getValue()}); -->
	<!--        		Ext.apply(params, {periodoVariable : periodoVariable.getValue()}); -->
	<!--        		Ext.apply(params, {informeLetrado : informeLetrado.getValue()}); -->
	<%--        		Ext.apply(params, {contratosIncluidos : '${contratosIncluidos}'}); --%>
	<!--        		Ext.apply(params, {bienesIncluidos : comboBienes.getValue()}); -->
	       		
	       		Ext.Ajax.request({
					url: page.resolveUrl('mejacuerdo/crearTerminoAcuerdo')
					,method: 'POST'
	<!-- 				,params:{ -->
	<%-- 						idAcuerdo : '${idAcuerdo}'  --%>
	<!-- 						,idTipoAcuerdo : comboTipoAcuerdo.getValue() -->
	<!-- 						,idTipoProducto : comboTipoProducto.getValue()  -->
	<!-- 						,modoDesembolso : modoDesembolso.getValue() -->
	<!-- 						,formalizacion : formalizacion.getValue() -->
	<!-- 						,importe : importe.getValue() -->
	<!-- 						,comisiones : comisiones.getValue() -->
	<!-- 						,periodoCarencia : periodoCarencia.getValue() -->
	<!-- 						,periodicidad : periodicidad.getValue() -->
	<!-- 						,periodoFijo : periodoFijo.getValue()	 -->
	<!-- 						,sistemaAmortizacion : sistemaAmortizacion.getValue()	 -->
	<!-- 						,interes : interes.getValue()	 -->
	<!-- 						,periodoVariable : periodoVariable.getValue() -->
	<!-- 						,informeLetrado : informeLetrado.getValue() -->
	<%-- 						,contratosIncluidos : '${contratosIncluidos}' --%>
	<!-- 						,bienesIncluidos : comboBienes.getValue() -->
	<!--       				} -->
					,params:params 
					,success: function (result, request){
						 Ext.MessageBox.show({
				            title: 'Guardado',
				            msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.mensajeGuardadoOK" text="**GuardadoCorrecto" />',
				            width:300,
				            buttons: Ext.MessageBox.OK
				        });
						page.fireEvent(app.event.DONE);
					}
					,error: function(){
						Ext.MessageBox.show({
				           title: 'Guardado',
				           msg: '<s:message code="plugin.mejoras.asunto.ErrorGuardado" text="**Error guardado" />',
				           width:300,
				           buttons: Ext.MessageBox.OK
				       });
						page.fireEvent(app.event.CANCEL);
					}       				
				});	
			
			}	
       		
     	}		
	});
	
	var bienesRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);	
	
   var bienesStore = page.getStore({
		eventName : 'listado'
		,flow:'mejacuerdo/obtenerListadoBienesAcuerdoByAsuId'
		,reader: new Ext.data.JsonReader({
	        root: 'bienes'
		}, bienesRecord)
	});	
			
	bienesStore.webflow({idAsunto:idAsunto});			
	config.store = bienesStore;	
	
	var comboBienes = app.creaDblSelect(null,'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.combo" text="**Bienes del asunto/Bienes para daci�n" />',config); 
	

	var bienesFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.titulo" text="**Bienes de la propuesta y garant�as seleccionadas"/>'
		,layout:'form'
		,autoWidth: true
		,autoHeight: true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,items : [
		 	comboBienes
		]		
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
	});	                                            	

   var panelAltaTermino=new Ext.Panel({
		layout:'form'
		,border : false
		,bodyStyle:'padding:5px;margin:5px'
		,width: 800
		,height: 400
		,autoScroll: true
		,nombreTab : 'altaTermino'
		,items : [flujoFieldSetContenedor, bienesFieldSet, detalleFieldSetContenedor, informeFieldSet]
		<c:choose>
		    <c:when test="${termino != null && termino != ''}">
		       ,bbar : [btnGuardar, btnCancelar]
		    </c:when>
		    <c:otherwise>
				,bbar : [btnGuardar,btnCancelar]
		    </c:otherwise>
		</c:choose>
				
	});	
	
	Ext.onReady(function () {
		
		<!-- Modo Visualizacion -->
		if("${termino}"!=null && "${termino}"!=''){
			
			
			if("${termino.tipoAcuerdo.id}"!=null && "${termino.tipoAcuerdo.id}"!=''){
				comboTipoAcuerdo.store.load();
		    	comboTipoAcuerdo.store.on('load', function(){  
		        	comboTipoAcuerdo.setValue(${termino.tipoAcuerdo.id});
		        	creaCamposDynamics(comboTipoAcuerdo);
		        	
	        		if("${operacionesPorTipo}"!=null && "${operacionesPorTipo}"!=''){
			       		<c:forEach var="operacion" items="${operacionesPorTipo}">
					    	Ext.getCmp('${operacion.nombre}').setValue('${operacion.valor}');
					    	Ext.getCmp('${operacion.nombre}').setDisabled(false);
						</c:forEach>
			       	}
		       	});
		       	
		       	
	       	}
	       	
	       	if("${termino.subtipoAcuerdo.id}"!=null && "${termino.subtipoAcuerdo.id}"!=''){
		       	comboSubTipoAcuerdo.store.load();
		    	comboSubTipoAcuerdo.store.on('load', function(){  
		        	comboSubTipoAcuerdo.setValue(${termino.subtipoAcuerdo.id});
		       	});
	       	}
	       	
	       	if("${termino.tipoProducto.id}"!=null && "${termino.tipoProducto.id}"!=''){
	       		comboTipoProducto.store.load();
		    	comboTipoProducto.store.on('load', function(){  
		        	comboTipoProducto.setValue(${termino.tipoProducto.id});
		       	});
	       	}
	       	
	       	if("${termino.bienes}"!=null && "${termino.bienes}"!=''){
	       		bienesStore.on('load', function(){  
		        	<c:forEach var="bien" items="${termino.bienes}">
				    	comboBienes.setValue("${bien.bien.id}"); 
					</c:forEach>
		       	});

	       	}
	       	
	       	if("${termino.informeLetrado}"!=null && "${termino.informeLetrado}"!=''){
	       		informeLetrado.setValue("${termino.informeLetrado}");
	       	}
	       	
	       	comboTipoAcuerdo.setDisabled(false);
	       	comboSubTipoAcuerdo.setDisabled(false);
	       	comboTipoProducto.setDisabled(false);
	       	comboBienes.setDisabled(false);
	       	informeLetrado.setDisabled(false);
	       	
		}
	});
		

	page.add(panelAltaTermino);


</fwk:page>  
