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
	    
	    var cmpLft = Ext.getCmp('dinamicElementsLeft');
	   	if (cmpLft) {
	     	detalleFieldSet.remove(cmpLft, true);
	   	}
	   	
	  	var cmpRgt = Ext.getCmp('dinamicElementsRight');
	   	if (cmpRgt) {
	     	detalleFieldSet.remove(cmpRgt, true); 
	   	}
	   	
	   	var v = this.getValue();
    	var r = this.findRecord(this.valueField || this.displayField, v);
    
	    var campos = arrayCampos[r.data.codigo];
	    
	    if(typeof(campos) != "undefined"){
	    
	        var dinamicElementsLeft = [];
	    	var dinamicElementsRight = [];
	    	
	    	for(var i=0;i < campos.length;i++){
	    		
	    		var campo=campos[i];
	    		
	    		if (i%2 == 0)
	    			dinamicElementsLeft.push(campo);
	    		else
	    			dinamicElementsRight.push(campo);
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

    });
	
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
	
<!-- 	CAMPOS TIPO ACUERDO REFINANCIACION SINDICADA-->
arrayCampos["08"] =[
				app.creaNumber('importePagoPrevio', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.agregar.detalles.importepagoprevio" text="**Importe pago previo formalización" />' , '', ''),
  				app.creaNumber('numPagos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Plazos pago previo formalización" />' , '', ''),
				app.creaNumber('carencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.carencia" text="**Carencia" />' , '', ''),
				app.creaNumber('cuotaAsumible', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cuaotaAsumible" text="**Cuota asumible cliente" />' , '', ''),
				app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', ''),
				app.creaText('garantiasExtras', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.garantiasExtras" text="**Garantias extras" />' , '', ''),
				app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**Nº expediente" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO REFINANCIACION -->


<!-- 	CAMPOS TIPO ACUERDO REFINANCIACION -->
arrayCampos["04"] =[
				app.creaNumber('importePagoPrevio', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.agregar.detalles.importepagoprevio" text="**Importe pago previo formalización" />' , '', ''),
  				app.creaNumber('numPagos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Plazos pago previo formalización" />' , '', ''),
				app.creaNumber('carencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.carencia" text="**Carencia" />' , '', ''),
				app.creaNumber('cuotaAsumible', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cuaotaAsumible" text="**Cuota asumible cliente" />' , '', ''),
				app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', ''),
				app.creaText('garantiasExtras', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.garantiasExtras" text="**Garantias extras" />' , '', ''),
				app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**Nº expediente" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO REFINANCIACION -->
	
	
<!-- 	CAMPOS TIPO ACUERDO DACIÓN EN PAGO -->
var dictSINO = <app:dict value="${SINO}" blankElement="true" blankElementValue="" blankElementText="---" />;
arrayCampos["01"] =[
				app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', ''),
				app.creaCombo({data:dictSINO,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solicitarAlquiler" text="**Solicitar alquiler" />',name:'solicitarAlquiler'}),
				app.creaNumber('liquidezAportada', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.liquidezAportada" text="**Liquidez aportada" />' , '', ''),
				app.creaNumber('tasacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.tasacion" text="**Tasación" />' , '', ''),
				app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**Nº expediente" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO DACIÓN EN PAGO -->


<!-- 	CAMPOS TIPO ACUERDO DACIÓN PARA PAGO -->
var dictSINO = <app:dict value="${SINO}" blankElement="true" blankElementValue="" blankElementText="---" />;
arrayCampos["03"] =[
				app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', ''),
				app.creaCombo({data:dictSINO,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solicitarAlquiler" text="**Solicitar alquiler" />',name:'solicitarAlquiler'}),
				app.creaNumber('liquidezAportada', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.liquidezAportada" text="**Liquidez aportada" />' , '', ''),
				app.creaNumber('tasacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.tasacion" text="**Tasación" />' , '', ''),
				app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroExpediente" text="**Nº expediente" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO DACIÓN PARA PAGO -->

<!-- 	CAMPOS TIPO ACUERDO COMPRAVENTA -->
var dictSINO = <app:dict value="${SINO}" blankElement="true" blankElementValue="" blankElementText="---" />;
arrayCampos["10"] =[
				app.creaNumber('cargasPosteriores', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cargasPosteriores" text="**Cargas posteriores" />' , '', ''),
				app.creaCombo({data:dictSINO,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solicitarAlquiler" text="**Solicitar alquiler" />',name:'solicitarAlquiler'}),
				app.creaNumber('liquidezAportada', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.liquidezAportada" text="**Liquidez aportada" />' , '', ''),
				app.creaNumber('tasacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.tasacion" text="**Tasación" />' , '', ''),
				app.creaNumber('numExpediente', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroExpediente" text="**Nº expediente" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO COMPRAVENTA -->


<!-- 	CAMPOS TIPO ACUERDO QUITA SOBRE LA DEUDA -->
arrayCampos["05"] =[
				app.creaNumber('importeApagar', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeApagar" text="**Importe a pagar" />' , '', ''),
				app.creaNumber('porcentajeQuita', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.porcentajeQuita" text="** % Quita" />' , '', ''),
				app.creaNumber('importeVencido', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeVencido" text="**Importe vencido" />' , '', ''),
				app.creaNumber('importeNoVencido', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeNoVencido" text="**Importe no vencido" />' , '', ''),
				app.creaNumber('importeInteresesMoratorios', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeInteresesMoratorios" text="**Importe intereses moratorios" />' , '', ''),
				app.creaNumber('importeInteresesOrdinarios', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeInteresesOrdinarios" text="**Importe intereses ordinarios" />' , '', ''),
				app.creaNumber('comisiones', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.comisiones" text="**Comisiones" />' , '', ''),
				app.creaNumber('gastos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.gastos" text="**Gastos" />' , '', ''),
				
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO QUITA SOBRE LA DEUDA -->

<!-- 	CAMPOS TIPO ACUERDO CESION DE REMATE -->
var fechaPago = new Ext.form.DateField({
	id:'fechaPago'
	,name:'fechaPago'
	,value : ''
	, allowBlank : true
	,autoWidth:true
	 ,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.fechaPago" text="**Fecha pago" />'
});
arrayCampos["11"] =[
				app.creaText('nombreCesionario', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.nombreCesionario" text="**Nombre cesionario" />' , '', ''),
				app.creaText('relacionCesionarioTitular', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.relacionCesionarioTitular" text="**Relacion cesionario / Titular" />' , '', ''),
				app.creaNumber('solvenciaCesionario', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.solvenciaCesionario" text="**Solvencia cesionario" />' , '', ''),
				app.creaNumber('importeCesion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importeCesion" text="**Importe cesión" />' , '', ''),
				fechaPago,
				
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO CESION DE REMATE -->


<!-- 	CAMPOS TIPO ACUERDO REGULARIZACION -->
var fecha = new Ext.form.DateField({
	id:'fecha'
	,name:'fecha'
	,value : ''
	, allowBlank : true
	,autoWidth:true
	 ,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.fecha" text="**Fecha" />'
});
arrayCampos["13"] =[
				fecha,
				app.creaNumber('frecuencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.frecuencia" text="**Frecuencia" />' , '', ''),
				app.creaNumber('numeroPagos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Número pagos" />' , '', ''),
				app.creaNumber('importe', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**Importe" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO REGULARIZACION -->


<!-- 	CAMPOS TIPO ACUERDO CANCELACIÓN -->
arrayCampos["14"] =[
				fecha,
				app.creaNumber('frecuencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.frecuencia" text="**Frecuencia" />' , '', ''),
				app.creaNumber('numeroPagos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Número pagos" />' , '', ''),
				app.creaNumber('importe', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**Importe" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO CANCELACIÓN -->

<!-- 	CAMPOS TIPO ACUERDO PLAN DE PAGOS -->
arrayCampos["17"] =[
				fecha,
				app.creaNumber('frecuencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.frecuencia" text="**Frecuencia" />' , '', ''),
				app.creaNumber('numeroPagos', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Número pagos" />' , '', ''),
				app.creaNumber('importe', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**Importe" />' , '', ''),
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO PLAN DE PAGOS -->

<!-- 	CAMPOS TIPO ACUERDO ENTREGA VOLUNTARIA DE LLAVES -->
var analisisSolvencia = new Ext.form.HtmlEditor({
		id:'note'
		,name : 'analisisSolvencia'
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
		
arrayCampos["15"] =[
		analisisSolvencia
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO ENTREGA VOLUNTARIA DE LLAVES -->


<!-- 	CAMPOS TIPO ACUERDO ALQUILER ESPECIAL -->
var alquilerEspecial = new Ext.form.HtmlEditor({
		id:'note'
		,name : 'alquilerEspecial'
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
		
arrayCampos["16"] =[
		alquilerEspecial
];
<!-- se crea un array asociativo y el identificador debe de ser el codigo del tipo de acuerdo -->
<!-- FIN CAMPOS TIPO ACUERDO ALQUILER ESPECIAL -->
	
	var modoDesembolso = app.creaText('modoDesembolso', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.modoDesembolso" text="**modoDesembolso" />' , '', {labelStyle:labelStyle});
	var formalizacion = app.creaText('formalizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.formalizacion" text="**formalizacion" />' , '', {labelStyle:labelStyle});
	var importe = app.creaNumber('importe', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.importe" text="**importe" />' , '', {labelStyle:labelStyle});
	var comisiones = app.creaNumber('comisiones', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.comisiones" text="**comisiones" />' , '', {labelStyle:labelStyle});
	var periodoCarencia = app.creaText('periodoCarencia', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoCarencia" text="**periodoCarencia" />' , '', {labelStyle:labelStyle});
	var periodicidad = app.creaText('periodicidad', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodicidad" text="**periodicidad" />' , '', {labelStyle:labelStyle});
	var periodoFijo = app.creaText('periodoFijo', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoFijo" text="**periodoFijo" />' , '', {labelStyle:labelStyle});
	var sistemaAmortizacion = app.creaText('sistemaAmortizacion', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.amortizacion" text="**sistemaAmortizacion" />' , '', {labelStyle:labelStyle});
	var interes = app.creaNumber('interes', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.interes" text="**interes" />' , '', {labelStyle:labelStyle});
	var periodoVariable = app.creaText('periodoVariable', '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.periodoVariable" text="**periodoVariable" />' , '', {labelStyle:labelStyle});
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
	
	
	var flujoFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.titulo" text="**Flujo"/>'
		,autoWidth: true
		,autoHeight: true
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
		 	{items:[comboTipoAcuerdo,comboSubTipoAcuerdo,comboTipoProducto],width:450}
		]
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
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.informe" text="**Informe letrado"/>'
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
       		
       		var params = detalleFieldSet.getForm().getValues();
       		
       		Ext.apply(params, {idAcuerdo : '${idAcuerdo}' });
       		Ext.apply(params, {idTipoAcuerdo : comboTipoAcuerdo.getValue()});
       		Ext.apply(params, {idSubTipoAcuerdo : comboSubTipoAcuerdo.getValue()});
       		Ext.apply(params, {idTipoProducto : comboTipoProducto.getValue()});
       		Ext.apply(params, {modoDesembolso : modoDesembolso.getValue()});
       		Ext.apply(params, {formalizacion : formalizacion.getValue()});
       		Ext.apply(params, {importe : importe.getValue()});
       		Ext.apply(params, {comisiones : comisiones.getValue()});
       		Ext.apply(params, {periodoCarencia : periodoCarencia.getValue()});
       		Ext.apply(params, {periodicidad : periodicidad.getValue()});
       		Ext.apply(params, {periodoFijo : periodoFijo.getValue()});
       		Ext.apply(params, {sistemaAmortizacion : sistemaAmortizacion.getValue()});
       		Ext.apply(params, {interes : interes.getValue()});
       		Ext.apply(params, {periodoVariable : periodoVariable.getValue()});
       		Ext.apply(params, {informeLetrado : informeLetrado.getValue()});
       		Ext.apply(params, {contratosIncluidos : '${contratosIncluidos}'});
       		Ext.apply(params, {bienesIncluidos : comboBienes.getValue()});
       		
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
	
	var comboBienes = app.creaDblSelect(null,null,config); 
	

	var bienesFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.titulo" text="**Bienes de la propuesta"/>'
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
		,autoWidth: true
		,autoHeight: true
		,nombreTab : 'altaTermino'
		,items : [flujoFieldSet, bienesFieldSet, detalleFieldSetContenedor, informeFieldSet]		
		,bbar : [btnGuardar,btnCancelar]		
	});	
		

	page.add(panelAltaTermino);


</fwk:page>  
