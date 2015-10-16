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

debugger;

	var importeStoreCon = new Ext.data.ArrayStore({
	    fields: ['id', 'codigo', 'desde', 'hasta'],
	    idIndex: 0 // id for each record will be the first element
	});

	var myData = [
	        [1, 'A', 1111, 3222],
	        [2, 'B', 1111, 3222],
	        [3, 'C', 1111, 3222],
	        [4, 'D', 1111, 3222]
	];
	importeStoreCon.loadData(myData);	
	
	var importeCm = new Ext.grid.ColumnModel([	    
		{header: '<s:message code="plugin.config.esquematurnado.editar.grid.id" text="**id"/>', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.codigo" text="**Codigo"/>', dataIndex: 'codigo'}
		,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.desde" text="**Desde"/>', dataIndex: 'desde'}
		,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.hasta_des" text="**Hasta"/>', dataIndex: 'hasta'}
	]);

	var importeGridCon = new Ext.grid.EditorGridPanel({
		store: importeStoreCon
		,cm: importeCm
		,title:'<s:message code="plugin.config.esquematurnado.buscador.tituloGrid" text="**Esquemas encontrados"/>'
		,stripeRows: true
		,autoHeight:true
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		//,selModel: sm
	});



	var innerConcursosPanelR = new Ext.Panel({
		layout:'table'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {columns:2}
		,autoWidth:true
		,style:'margin-top:20px'
		,bodyStyle:'padding:5px;cellspacing:10px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{layout:'panel',items:[importeGridCon]}
			,{layout:'panel',items:[importeGridCon]}
		]
	});

	var turnadoConcursosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelConcursos.titulo" text="**Turnado Concursos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[conLimitStockAnual,innerConcursosPanelR]}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});


	var turnadoLitigiosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelLitigios.titulo" text="**Turnado Litigos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;margin:10px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[litLimitStockAnual]}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var mainPanel = new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{
					layout:'form'
					,items: [nombreEsquemaTurnado,turnadoConcursosFieldSet,turnadoLitigiosFieldSet]}
				]
	});	
	page.add(mainPanel);
	
	
</fwk:page>


