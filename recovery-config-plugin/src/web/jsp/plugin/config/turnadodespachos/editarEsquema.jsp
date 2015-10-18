<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var estadoPendiente = true; // estado pendiente
	var estadoVigente = false; // estado vigente
	var modoConsulta = false; // Usuario diferente o histórico
	if(modoConsulta) {
		estadoVigente = estadoPendiente = false;
	};

	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.editar.campo.nombre"
		label="**Nombre esquema turnado"
		name="nombreEsquemaTurnado"
		value="${data.descripcion}"
		readOnly="false" />
	
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.editar.campo.limiteStockAnualLitigios"
		label="**Limitacion por stock Anual"
		name="litLimitStockAnual"
		value="${data.limiteStockAnualLitigios}"
		readOnly="false" />
		
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.editar.campo.limiteStockAnualConcursos"
		label="**Limitacion por stock Anual"
		name="conLimitStockAnual"
		value="${data.limiteStockAnualConcursos}"
		readOnly="false" />

   // DEFINICION TIPOS GRIDs 
	var TipoImporte = Ext.data.Record.create([
	    {name: 'id', type: 'int', mapping:0},
	    {name: 'codigo', mapping:1},
	    {name: 'desde', type: 'float', mapping:2},
	    {name: 'hasta', type: 'float', mapping:3}
	]);
	var TipoCalidad = Ext.data.Record.create([
	    {name: 'id', type: 'int', mapping:0},
	    {name: 'codigo', mapping:1},
	    {name: 'porcentaje', type: 'float', mapping:2}
	]);

   // STOREs GRIDs 
    var storeImpCon = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoImporte)
    });
    var storeCalCon = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoCalidad)
    });
    var storeImpLit = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoImporte)
    });
    var storeCalLit = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoCalidad)
    });

   // DATOS GRIDs
	var newTipoImporteRow = function(id,codigo,desde,hasta) {
		return new TipoImporte({id:id,codigo:codigo,desde:desde,hasta:hasta});
	}
	var newTipoCalidadRow = function(id,codigo,porcentaje) {
		return new TipoImporte({id:id,codigo:codigo,porcentaje:porcentaje});
	}

	storeImpCon.add(newTipoImporteRow(1,'A',1.1,2.2));
	storeImpCon.add(newTipoImporteRow(2,'B',1.1,2.2));
	storeImpCon.add(newTipoImporteRow(3,'C',1.1,2.2));

	storeCalCon.add(newTipoCalidadRow(1,'A',11.1));
	storeCalCon.add(newTipoCalidadRow(2,'C',11.1));

	storeImpLit.add(newTipoImporteRow(1,'A',1.1,2.2));
	storeImpLit.add(newTipoImporteRow(2,'B',1.1,2.2));
	storeImpLit.add(newTipoImporteRow(3,'C',1.1,2.2));

	storeCalLit.add(newTipoCalidadRow(1,'A',11.1));
	storeCalLit.add(newTipoCalidadRow(2,'C',11.1));

	// GRID 
	var txtGridEditor = function() {
		return new Ext.form.TextField({
			allowBlank: false
		});
	};

	var addBotoneraGrid = function(grid, newRowFunction) {
		if (modoConsulta || estadoVigente) return;
		grid.getBottomToolbar().addButton({
			grid: grid,
			text: 'Nuevo',
			iconCls : 'icon_mas',
			handler: function() {
				var row = newRowFunction();
				var store = this.grid.store;
				this.grid.stopEditing();
				store.add(row);
				var pos = store.getCount() - 1;
				this.grid.getSelectionModel().selectRow(pos);
				this.grid.startEditing(pos, 1);
			}
		});
		grid.getBottomToolbar().addButton({
			grid: grid,
			text: 'Borrar',
			iconCls : 'icon_menos',
			handler: function() {
			}
		});
	}
	
	var importeCm = function() {
		var varTxtEditor = null;
		var varTxtEditorValores = null;
		if (estadoPendiente) {
			varTxtEditorValores = 
				varTxtEditor = txtGridEditor;
		} else if (estadoVigente) {
			varTxtEditorValores = txtGridEditor;
		}		
		return new Ext.grid.ColumnModel([
			{header: '<s:message code="plugin.config.esquematurnado.editar.grid.id" text="**id"/>', dataIndex: 'id', hidden: true}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.codigo" text="**Codigo"/>', dataIndex: 'codigo', width: 75, editor: varTxtEditor}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.desde" text="**Desde"/>', dataIndex: 'desde', width: 100, editor: varTxtEditorValores}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.hasta_des" text="**Hasta"/>', dataIndex: 'hasta', width: 100, editor: varTxtEditorValores}
		]);
	};
 	
	var calidadCm = function() {
		var varTxtEditor = null;
		var varTxtEditorValores = null;
		if (estadoPendiente) {
			varTxtEditorValores = 
				varTxtEditor = txtGridEditor;
		} else if (estadoVigente) {
			varTxtEditorValores = txtGridEditor;
		}		
		return new Ext.grid.ColumnModel([	    
			{header: '<s:message code="plugin.config.esquematurnado.editar.grid.id" text="**id"/>', dataIndex: 'id', hidden: true}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.codigo" text="**Codigo"/>', dataIndex: 'codigo', width: 70, editor: varTxtEditor}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.porcentaje" text="**Porcentaje"/>', dataIndex: 'porcentaje', width: 100, editor: varTxtEditorValores}
		]);
	};

	var importeConcursalGrid = new Ext.grid.EditorGridPanel({
		store: storeImpCon
		,cm: importeCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.importe.grid.titulo" text="**Tipo importe Con"/>'
		,autoExpandColumn: 'common' // column with this id will be expanded
		,stripeRows: true
		//,autoHeight:true
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(importeConcursalGrid, newTipoImporteRow);

	var calidadConcursalGrid = new Ext.grid.EditorGridPanel({
		store: storeCalCon
		,cm: calidadCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.calidad.grid.titulo" text="**Tipo calidad Con"/>'
		,stripeRows: true
		//,autoHeight:true
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(calidadConcursalGrid, newTipoCalidadRow);

	var innerConcursosPanelGrids = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:2}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [importeConcursalGrid]}
				,{layout:'form'
					,items: [calidadConcursalGrid]}
				]
	});	

	var turnadoConcursosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelConcursos.titulo" text="**Turnado Concursos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [
		 	{items:[conLimitStockAnual,innerConcursosPanelGrids]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(600-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});


	var importeLitigiosGrid = new Ext.grid.EditorGridPanel({
		store: storeImpLit
		,cm: importeCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.importe.grid.titulo" text="**Tipo importe Lit"/>'
		,stripeRows: true
		//,autoHeight:true
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(importeLitigiosGrid, newTipoImporteRow);

	var calidadLitigiosGrid = new Ext.grid.EditorGridPanel({
		store: storeCalLit
		,cm: calidadCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.calidad.grid.titulo" text="**Tipo calidad Lit"/>'
		,stripeRows: true
		//,autoHeight:true
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar:[]
	});
	addBotoneraGrid(calidadLitigiosGrid, newTipoCalidadRow);

	var innerLitigosPanelGrids = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:2}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [importeLitigiosGrid]}
				,{layout:'form'
					,items: [calidadLitigiosGrid]}
				]
	});	

	var turnadoLitigiosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelLitigios.titulo" text="**Turnado Litigos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [
		 	{items:[litLimitStockAnual,innerLitigosPanelGrids]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(600-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
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
		<app:test id="btnGuardarABM" addComa="true"/>
	});

	var mainButtonBar = (estadoVigente || estadoPendiente) ? [btnGuardar,btnCancelar] : [btnCancelar];
	var mainPanel = new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,bbar: mainButtonBar
		,items:[{
			layout:'form'
			,items: [nombreEsquemaTurnado,turnadoConcursosFieldSet,turnadoLitigiosFieldSet]}
		]
	});	

	page.add(mainPanel);
	
</fwk:page>


