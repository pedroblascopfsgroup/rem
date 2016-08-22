<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var procedimiento=app.creaLabel('<s:message code="embargobienes.tramite" text="**Tramite"/>','TRÁMITE DE SUBASTA');
	procedimiento.on('dblclick',function(){
		alert('epa');
	});
	
	var tarea=app.creaLabel('<s:message code="embargobienes.tarea" text="**Tarea"/>','Solicitud de subasta');
	var asunto=app.creaLabel('<s:message code="embargobienes.asunto" text="**Asunto"/>','23143124');
	var contrato=app.creaLabel('<s:message code="embargobienes.contrato" text="**Contrato"/>','34562345698745');
	var clientes={clientes:[
		{codigo: '1',nombre:'Juan Lopez Cuerda'}
		,{codigo: '2',nombre:'Salvador Valero Marin'}
		,{codigo: '3',nombre:'Martin Martin Martin'}
	]};
	var clientesStore = new Ext.data.JsonStore({
        fields: ['codigo', 'nombre']
        ,root: 'clientes'
        ,data : clientes
    });
	var clientesList = new Ext.ux.Multiselect({
        store: clientesStore
        ,fieldLabel: '<s:message code="embargobienes.clientes" text="**Clientes" />'
        ,displayField:'nombre'
        ,valueField: 'codigo'
        ,labelStyle:'font-weight:bolder'
        ,height : 80
        ,width : 200
    });
    var bienes = {bienes :[	
    	{bien: 'Apartamento Playa', tipo : 'Inmueble',participacion:'50%',valor:'300000',cargas:'180000',embargo:true}
    	,{bien: 'Chalet Montaña', tipo : 'Inmueble',participacion:'100%',valor:'1300000',cargas:'800000',embargo:false}
    	,{bien: 'Otro', tipo : 'Otro',participacion:'80%',valor:'200000',cargas:'18000',embargo:true}
    	]};
    var bienesStore = new Ext.data.JsonStore({
    	data : bienes
    	,root : 'bienes'
    	,fields : ['bien', 'tipo','participacion','valor','cargas','embargo']
    });
    //var checkColumn=app.creaCheckColumn('Embargo','embargo');
	
	//var sm=new Ext.CheckBo
	Ext.grid.CheckColumn = function(config){
	    Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
	    }
	    this.renderer = this.renderer.createDelegate(this);
	};
	
	Ext.grid.CheckColumn.prototype ={
	    init : function(grid){
	        this.grid = grid;
	        this.grid.on('render', function(){
	            var view = this.grid.getView();
	            view.mainBody.on('mousedown', this.onMouseDown, this);
	        }, this);
	    },
	
	    onMouseDown : function(e, t){
	        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();
	            var index = this.grid.getView().findRowIndex(t);
	            var record = this.grid.store.getAt(index);
	            record.set(this.dataIndex, !record.data[this.dataIndex]);
	        }
	    },
	
	    renderer : function(v, p, record){
	        p.css += ' x-grid3-check-col-td'; 
	        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    }
	};  


	var checkColumn = new Ext.grid.CheckColumn({header : '<s:message code="embargobienes.grid.embargar" text="**Embargar"/>',dataIndex:'embargo'});

	
    var bienesCm = new Ext.grid.ColumnModel([
    	{header  : '<s:message code="embargobienes.grid.bien" text="**Bien"/>', dataIndex : 'bien' }
    	,{header : '<s:message code="embargobienes.grid.tipo" text="**Tipo"/>', dataIndex : 'tipo' }
    	,{header : '<s:message code="embargobienes.grid.participacion" text="**Participacion"/>', dataIndex : 'participacion' }
    	,{header : '<s:message code="embargobienes.grid.valor" text="**Valor"/>', dataIndex : 'valor' }
    	,{header : '<s:message code="embargobienes.grid.cargas" text="**Cargas"/>', dataIndex : 'cargas' }
    	,checkColumn
    ]);
    var bienesGrid = app.crearGrid(bienesStore,bienesCm,{
		title:'<s:message code="embargobienes.grid.titulo" text="**Bienes" />'
    	,iconCls:'icon_bienes'
		//,sm: sm
		,style:'padding-right:10px'
    	,height : 150
		,plugins:checkColumn
		
    });
    var btnAsignar = new Ext.Button({
		text:'<s:message code="embargobienes.asignar" text="**Asignar" />'
		,iconCls:'icon_aplicar'
		
	});
    var panel = new Ext.form.FormPanel({
    	autoHeight : true
		//,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false,width:350,style:'padding-bottom:10px' }
				,items : [
					{ items : [ procedimiento,tarea,asunto,contrato ], style : 'margin-right:10px;padding-bottom:10px' }
					,{
						items : clientesList 
					}
				]
			}
			,bienesGrid
			,btnAsignar
		]
		,tbar:new Ext.Toolbar()
    });
    page.add(panel);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
</fwk:page>