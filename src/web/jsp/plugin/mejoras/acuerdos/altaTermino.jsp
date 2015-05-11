<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	//var labelStyleDescripcion = 'width:185x;height:60px;font-weight:bolder",width:700';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	
	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder"};
	var idAsunto = '${asunto.id}';
	
    var tipoAcu = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
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
		,width: 960
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
		 	{items:[comboTipoAcuerdo],width:450}
		]
	});	
	
	var detalleFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.titulo" text="**Detalle operaciones"/>'
		,autoHeight: true
		,autoWidth: true
		,border:true
		,style:'padding:0px'
		,layout:'table'
		,layoutConfig:{columns:3}	
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [{
					layout:'form'
					,items: [comboTipoProducto,importe,periodicidad,interes]
				},{
					layout:'form'
					,items: [modoDesembolso,comisiones,periodoFijo,periodoVariable]
				},{
					layout:'form'
					,items: [formalizacion,periodoCarencia,sistemaAmortizacion]
				}]
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
       		Ext.Ajax.request({
				url: page.resolveUrl('mejacuerdo/crearTerminoAcuerdo')
				,method: 'POST'
				,params:{
						idAcuerdo : '${idAcuerdo}' 
						,idTipoAcuerdo : comboTipoAcuerdo.getValue()
						,idTipoProducto : comboTipoProducto.getValue() 
						,modoDesembolso : modoDesembolso.getValue()
						,formalizacion : formalizacion.getValue()
						,importe : importe.getValue()
						,comisiones : comisiones.getValue()
						,periodoCarencia : periodoCarencia.getValue()
						,periodicidad : periodicidad.getValue()
						,periodoFijo : periodoFijo.getValue()	
						,sistemaAmortizacion : sistemaAmortizacion.getValue()	
						,interes : interes.getValue()	
						,periodoVariable : periodoVariable.getValue()
						,informeLetrado : informeLetrado.getValue()
						,contratosIncluidos : '${contratosIncluidos}'
						,bienesIncluidos : comboBienes.getValue()
      				}
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
	
	var comboBienes = app.creaDblSelect(null,'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.bienes" text="**Bienes" />',config); 
	

	var bienesFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.titulo" text="**Bienes de la propuesta"/>'
		,layout:'form'
		,autoWidth: true
		,autoHeight: true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,items : [
		 	{items:[comboBienes]}
		]		
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
	});	                                            	

   var panelAltaTermino=new Ext.Panel({
		layout:'form'
		,border : false
		,bodyStyle:'padding:5px;margin:5px'
		,autoWidth: true
		,autoHeight: true
		,nombreTab : 'altaTermino'
		,items : [flujoFieldSet, bienesFieldSet, detalleFieldSet, informeFieldSet]		
		,bbar : [btnGuardar,btnCancelar]		
	});	
		

	page.add(panelAltaTermino);


</fwk:page>  
