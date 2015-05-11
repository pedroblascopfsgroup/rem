<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>
	var favorito = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'nombre'}
		,{name:'tipo'}
	]);
	
	var favoritosStore = page.getStore({
		eventName : 'listado'
		,flow:'favoritos/mantenerFavoritos'
		,reader: new Ext.data.JsonReader({
	    	root : 'favoritos'
	    }, favorito)
	});
	favoritosStore.webflow();
	/**
	 * renderiza el icono de la tabla de favoritos según el tipo
	 */
	favIcon = function(value){
		var idx = parseInt(value);
		var icon;
		if (idx==app.constants.FAV_TIPO_CLIENTE) icon = 'usuario.gif';
		if (idx==app.constants.FAV_TIPO_EXPEDIENTE) icon = 'book_open.gif';
		if (idx==app.constants.FAV_TIPO_ASUNTO) icon = 'folder_page.gif';
		if (idx==app.constants.FAV_TIPO_PROCEDIMIENTO) icon = 'page_red.gif';
		if (idx==app.constants.FAV_TIPO_CONTRATO) icon = 'script.gif';
		return icon? "<img src='/${appProperties.appName}/css/" +icon + "' />" : value;
	};
	
	var columnModel =new Ext.grid.ColumnModel([
			{dataIndex : 'tipo', renderer : favIcon, width : 25}, 
			{header : 'Nombre', dataIndex : 'nombre', width : 110},
			{header : 'Codigo', hidden:true, dataIndex : 'codigo', width : 15}
			]);
	//añado tooltips a las columnas (sólo si tienen header)
		var ccfg = columnModel.config;
		for(var i=0;i < ccfg.length;i++){
			if (ccfg[i].header){
				ccfg[i].tooltip = ccfg[i].header;
			}
		}
	
	var clientesFav = new Ext.grid.GridPanel({
		store : favoritosStore
		,border : false
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,width : 150
		,viewConfig : { forceFit : true }
		,cm :columnModel 
		,autoHeight: true	
		,listeners : {
			rowdblclick : function(grid, rowIndex){
				var rec=this.getStore().getAt(rowIndex);
				var tipo=rec.get('tipo');
				switch(tipo){
					case app.constants.FAV_TIPO_EXPEDIENTE:
						app.abreExpediente(rec.get('codigo'), rec.get('nombre'));
						break;
					case app.constants.FAV_TIPO_CLIENTE:
						app.abreCliente(rec.get('codigo'), rec.get('nombre'));
						break;
					case app.constants.FAV_TIPO_ASUNTO:
						app.abreAsunto(rec.get('codigo'), rec.get('nombre'));
						break;
					case app.constants.FAV_TIPO_PROCEDIMIENTO:
						app.abreProcedimiento(rec.get('codigo'), rec.get('nombre'));
						break;
					case app.constants.FAV_TIPO_CONTRATO:
						app.abreContrato(rec.get('codigo'), rec.get('nombre'));
						break;							
				}
			}
			,render: function(g) {
				g.on("beforetooltipshow", function(grid, row, col, rowData) {
					grid.tooltip.body.update(rowData);
				});
			}
		}
 		,monitorResize: true
	    ,doLayout: function() {
			var parentSize = Ext.get(this.getEl().dom.parentNode).getSize(true); 
	     	this.setWidth(parentSize.width);
	     	Ext.grid.GridPanel.prototype.doLayout.call(this);
	    }
		
	});
	//implementa el tooltip para ver el contenido de las celdas
	clientesFav.onRender = function() {
        	Ext.grid.GridPanel.prototype.onRender.apply(this, arguments);
        	this.addEvents("beforetooltipshow");
	        this.tooltip = new Ext.ToolTip({
	        	renderTo: Ext.getBody(),
	        	target: this.view.mainBody,
	        	listeners: {
	        		beforeshow: function(qt) {
	        			var v = this.getView();
			            var rows = (this.store != null ? this.store.getCount() : 0);
			            if (rows <=0 ) return false;

			            var store = this.getStore();
			            var row = v.findRowIndex(qt.baseTarget);
						
			            var cell = v.findCellIndex(qt.baseTarget);
						
			            if (cell==false || cell!=1) return;
			            var field = this.getColumnModel().config[cell].dataIndex;
						
			            var rowData = this.getView().getCell(row,cell);
						
			            rowData = rowData.innerText? rowData.innerText : rowData.textContent;

			            if(rowData != this.lastRowData){
			            	this.fireEvent("beforetooltipshow", this, row, cell, rowData);
			            }
			            this.lastRowData = rowData;
			            if (!rowData) return false;
	        		},
	        		scope: this
	        	}
	        });
        };
	
	page.on('addfav', function(params){
		//recargar la pagina favoritos
		favoritosStore.webflow({
				entidadInformacion: params.tipo,
				idInformacion: params.id
			});
	});
	page.on('reloadFav',function(){
		favoritosStore.webflow();
	});


	page.add(clientesFav);
</fwk:page>