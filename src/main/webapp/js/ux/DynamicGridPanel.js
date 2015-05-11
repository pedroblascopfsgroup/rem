/**
 * 
 *   Ext.ux.DynamicGridPanel
 * 
 * Grid configurable con tamaño y tipo de datos dinámico, y expansores para agrupar.
 * La definición de datos y columnas viajan en el JSON junto con los datos, el
 * código original de este componente, con ej. de uso ver:
 * 
 *   @see http://erhanabay.com/2009/01/29/dynamic-grid-panel-for-ext-js/
 *    
 * Código original para agregar expansores:
 * 
 *   @see http://extjs.net/forum/showthread.php?t=29169
 * 
 * Para parsear un objeto JSON para esta clase se puede usar el DTO
 * es.capgemini.pfs.dynamicDto.DtoDynamicRow y el JSP generico/dtoDynamicJSON.jsp
 * 
 * También se agregó automáticamente tooltips para los datos como en app.creaGrid,
 * y la posibilidad de usar un mergue de todas las celdas de una fila con la propiedad
 * 'rowbody' en los datos.
 * 
 * TODO Pasar este componente a devon
 * 
 */



Ext.grid.RowExpander = function(config){
    Ext.apply(this, config);

    this.addEvents({
        beforeexpand : true,
        expand: true,
        beforecollapse: true,
        collapse: true
    });

    Ext.grid.RowExpander.superclass.constructor.call(this);

    if(this.tpl){
        if(typeof this.tpl == 'string'){
            this.tpl = new Ext.Template(this.tpl);
        }
        this.tpl.compile();
    }

    this.state = {};
    this.bodyContent = {};
};

Ext.extend(Ext.grid.RowExpander, Ext.util.Observable, {
    header: "",
    width: 20,
    sortable: false,
    fixed:true,
    menuDisabled:true,
    dataIndex: '',
    id: 'expander',
    lazyRender : true,
    enableCaching: true,

    getRowClass : function(record, rowIndex, p, ds){
        p.cols = p.cols-1;
        var content = this.bodyContent[record.id];
        if(!content && !this.lazyRender){
            content = this.getBodyContent(record, rowIndex);
        }
        if(content){
            p.body = content;
        }
		
        return this.state[record.id] ? 'x-grid3-row-expanded' : 'x-grid3-row-collapsed';
    },

    init : function(grid){
        this.grid = grid;

        var view = grid.getView();
        view.getRowClass = this.getRowClass.createDelegate(this);

        view.enableRowBody = true;

        grid.on('render', function(){
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    getBodyContent : function(record, index){
        if(!this.enableCaching){
            return this.tpl.apply(record.data);
        }
        var content = this.bodyContent[record.id];
        if(!content){
            content = this.tpl.apply(record.data);
            this.bodyContent[record.id] = content;
        }
        return content;
    },

    onMouseDown : function(e, t){
        if(t.className == 'x-grid3-row-expander'){
            e.stopEvent();
            var row = e.getTarget('.x-grid3-row');
            this.toggleRow(row);
        } 
    },

    renderer : function(v, p, record){
       	p.cellAttr = 'rowspan="2"';
        if(record.data.subdata.length > 0) {
            return '<div class="x-grid3-row-expander"> </div>';
        } else {
            return '';
        }
    },

    beforeExpand : function(record, body, rowIndex){
        if(this.fireEvent('beforeexpand', this, record, body, rowIndex) !== false){
            if(this.tpl && this.lazyRender){
                body.innerHTML = this.getBodyContent(record, rowIndex);
            }
			
	           return true;
        }else{
            return false;
        }
    },

    toggleRow : function(row){
        if(typeof row == 'number'){
            row = this.grid.view.getRow(row);
        }
        this[Ext.fly(row).hasClass('x-grid3-row-collapsed') ? 'expandRow' : 'collapseRow'](row);
    },
	
    expandRow : function(row){
        if(typeof row == 'number'){
            row = this.grid.view.getRow(row);
        }
        var record = this.grid.store.getAt(row.rowIndex);
        var body = Ext.DomQuery.selectNode('tr:nth(2) div.x-grid3-row-body', row);
        if(this.beforeExpand(record, body, row.rowIndex)){
            this.state[record.id] = true;
            Ext.fly(row).replaceClass('x-grid3-row-collapsed', 'x-grid3-row-expanded');
            this.fireEvent('expand', this, record, body, row.rowIndex);
        }
    },

    collapseRow : function(row){
        if(typeof row == 'number'){
            row = this.grid.view.getRow(row);
        }
        var record = this.grid.store.getAt(row.rowIndex);
        var body = Ext.fly(row).child('tr:nth(1) div.x-grid3-row-body', true);
        if(this.fireEvent('beforcollapse', this, record, body, row.rowIndex) !== false){
            this.state[record.id] = false;
            Ext.fly(row).replaceClass('x-grid3-row-expanded', 'x-grid3-row-collapsed');
            this.fireEvent('collapse', this, record, body, row.rowIndex);
        }
    }
});


Ext.ux.SubTableRowExpander = function(config){
	if (!config.subdata) { config.subdata = 'subdata'; }
    Ext.apply(this, config);

    Ext.ux.SubTableRowExpander.superclass.constructor.call(this);

    this.state = {};
    this.bodyContent = {};
	
};


Ext.extend(Ext.ux.SubTableRowExpander, Ext.grid.RowExpander, {
	enableCaching: false,
	
	init: function (grid) {
		
		 this.addEvents({
        	dblclick: true,
			mouseover: true,
			mouseout: true,
			subdblclick: true
			});
			
	    var ret = Ext.ux.SubTableRowExpander.superclass.init.call(this, grid);
		
		this.grid.view.afterMethod('onColumnHiddenUpdated', this.reconfigureTemplate, this);
		this.grid.view.afterMethod('onLayout', this.reconfigureTemplate, this);
		this.grid.view.afterMethod('onColumnWidthUpdated', this.doWidth, this);
		this.grid.view.afterMethod('onAllColumnWidthsUpdated', this.doAllWidths, this);
		this.grid.view.afterMethod('afterMove', this.doAllWidths, this);
		
		this.grid.on('dblclick', this.onDblClick, this);
		
		this.grid.store.on('load', function (store, records) { this.createSubdata(); }.createDelegate(this));
		this.createSubdata();
		
		this.on("expand", function (e, record) {
			var res = Ext.query("table.x-grid3-row-subtable");
			
			for (var i=0;i<res.length;i++) {
				
				Ext.fly(res[i]).on("mouseover", this.onMouseOver);
				Ext.fly(res[i]).on("mouseout", this.onMouseOut);
			}
			
			for (var i=0;i<record.subdata.records.length;i++) {

				Ext.fly("subtable-" + records.records[i].id).on("mouseover", this.onMouseOver);
				Ext.fly("subtable-" + records.records[i].id).on("mouseout", this.onMouseOut);
			}
			
			
			
		});
		
	},
    renderer : function(v, p, record){
       	p.cellAttr = 'rowspan="2"';
        if(record.data.subdata.length > 0) {
            return '<div class="x-grid3-row-expander"> </div>';
        } else {
            return '';
        }
    },
	createSubdata: function () {
		
		switch (this.reader) {
			case "array":
				var reader = new Ext.data.ArrayReader({}, this.grid.store.reader.recordType);
				break;
			case "json":
			default:
				var reader = new Ext.data.JsonReader({}, this.grid.store.reader.recordType);
				break;
		}
		
		for (j=0;j<this.grid.getStore().getCount();j++) {
			var record = this.grid.getStore().getAt(j);

			if (record.data[this.subdata] && record.data[this.subdata].length > 0) {
				record.subdata = this.processRenderMethod(reader.readRecords(record.data[this.subdata]));
			} else {
				record.subdata = {};
				record.subdata.records = new Array();
			}
		}
	},
	doWidth: function () {
		this.reconfigureTemplate();
		this.updateRows();
	},
	onDblClick : function(e){
		var t = e.target;

		if (Ext.fly(t.id)) {
			var target = Ext.fly(t.id);
			if (target.hasClass("x-grid3-cell-subtablerow")) {
				
				var parent = target.findParent("tr.x-grid3-subtable-outertable-row", 10);
				
				var parent2 = target.findParent(this.grid.view.rowSelector, 20);
				var record = this.grid.store.getAt(parent2.rowIndex).subdata.records[parent.rowIndex];

				this.fireEvent("subdblclick", record);
			}
		}
    },
	onMouseOver: function (e) {
		var t = e.target;

		if (Ext.fly(t.id)) {
			var target = Ext.fly(t.id);
			if (target.hasClass("x-grid3-cell-subtablerow")) {

				var parent = target.findParent("table.x-grid3-row-subtable", 10, true);
				parent.addClass("x-grid3-row-over");
			}
		}
	},
	onMouseOut: function (e) {
		var t = e.target;

		if (Ext.fly(t.id)) {
			var target = Ext.fly(t.id);
			if (target.hasClass("x-grid3-cell-subtablerow")) {
				var parent = target.findParent("table.x-grid3-row-subtable", 10, true);
				parent.removeClass("x-grid3-row-over");

			}
		}
	},
	fly : function(el){
        if(!this._flyweight){
            this._flyweight = new Ext.Element.Flyweight(document.body);
        }
        this._flyweight.dom = el;
        return this._flyweight;
    },
	updateRow: function (row) {
		var record = this.grid.store.getAt(row);

	    if(typeof row == 'number'){
	        row = this.grid.view.getRow(row);
	    }
	    
	    var body = Ext.DomQuery.selectNode('tr:nth(2) div.x-grid3-row-body', row);
		
		records = record.subdata;

		var content = this.tpl.apply(records.records);
		
		this.bodyContent[record.id] = content;
	   	body.innerHTML = content;
		
	},
	updateRows: function () {
      	var ns = this.grid.view.getRows();
        for(var i = 0, len = ns.length; i < len; i++){
			this.updateRow(i);
		}
	},
	doAllWidths: function () {
		this.reconfigureTemplate();
		this.updateRows();
	},	
	getActivatedGridColumns: function () {
		var cm = this.grid.getColumnModel();
		
		var cols = [];
		
		
		
		for(var i = 0; i < cm.getColumnCount(); i++){
			if (!cm.isHidden(i)) {
				var col = {};
				var name = cm.getDataIndex(i);
				col.name = (typeof name == 'undefined' ? this.ds.fields.get(i).name : name);
				col.index = i;
				col.width = this.getColumnWidth(i);
				col.renderer = cm.getRenderer(i);
				cols.push(col);
			}
		}
		
		return cols;
	},
	getColumnWidth : function(col){
		var cm = this.grid.getColumnModel();
		
        var w = cm.getColumnWidth(col);
        if(typeof w == 'number'){
            w = (Ext.isBorderBox ? w : (w-this.grid.view.borderWidth > 0 ? w-this.grid.view.borderWidth:0));
        }
		
        return w;
    },
		
	reconfigureTemplate: function () {
		var cols = this.getActivatedGridColumns();

		var template = [
							'<table class="x-grid3-subtable-outertable" cellspacing="0">',
							'<tpl for=".">'
						];

		
		
		var padding, colWidth;
		
		template.push('<tr class="x-grid3-subtable-outertable-row"><td><table cellspacing="0" id="subtable-{values.id}" cellpadding="0" class="x-grid3-row-subtable"><tr class="x-grid3-row x-grid3-subtable-row-alt">');
		
		for(var i = 1; i < cols.length; i++){
			
			
			if (i == 1) {
				padding = '';
			} else {
				padding = '';
			}
		
			colWidth = cols[i].width;
			template.push('<td class="x-grid3-col x-grid3-cell x-grid3-td-'+cols[i].name+'" style="width: '+colWidth+'px;"><div style="'+padding+'" unselectable="on" id="subfield-{values.id}-'+cols[i].name+'" class="x-grid3-cell-subtablerow x-grid3-cell-inner x-grid3-col-'+cols[i].name+'">' + '{values.data.' + cols[i].name + '}</div></td>');
		}
		
		template.push('</tr>');
		template.push('</table></td></tr></tpl></table>');
		
		this.tpl = new Ext.XTemplate(template);
					
	    if(this.tpl){
	        if(typeof this.tpl == 'string'){
	            this.tpl = new Ext.Template(this.tpl);
	        }
	        this.tpl.compile();
	    }
				
		return;
		
	},
	processRenderMethod: function (records) {
		var cols = this.getActivatedGridColumns();

		for (var i=0;i<records.records.length;i++) {
			for(var j = 1; j< cols.length; j++){
				records.records[i].data[cols[j].name] = cols[j].renderer(records.records[i].data[cols[j].name],
																		 {},
																		 records.records[i]);
			}
		}
		
		return records;
	},
    getBodyContent : function(record, index){
		records = record.subdata;
		
		var body = "";
				
		if (records.records.length > 0) {
			body = this.tpl.apply(records.records);
		}
		this.bodyContent[record.id] = body;
		
		return body;
    }
});



var expander = new Ext.ux.SubTableRowExpander({
	//reader: 'json',
	subdata: 'subdata'
});


/**
 * Clase para crear grids con cantidad de columnas y tipos de datos variables.
 */
Ext.ux.DynamicGridPanel = Ext.extend(Ext.grid.GridPanel, {

  initComponent: function(){
    /**
     * Default configuration options.
     *
     * You are free to change the values or add/remove options.
     * The important point is to define a data store with JsonReader
     * without configuration and columns with empty array. We are going
     * to setup our reader with the metaData information returned by the server.
     * See http://extjs.com/deploy/dev/docs/?class=Ext.data.JsonReader for more
     * information how to configure your JsonReader with metaData.
     *
     * A data store with remoteSort = true displays strange behaviours such as
     * not to display arrows when you sort the data and inconsistent ASC, DESC option.
     * Any suggestions are welcome
     */
    var config = {
      viewConfig: {forceFit:true, enableRowBody:true, getRowClass:this.getRowClass},
      enableColLock: false,
      loadMask: true,
      stripeRows: true,
      ds: new Ext.data.Store({
		    url: this.storeUrl,
		    reader: new Ext.data.JsonReader()
		  }),
      columns: []
		,frame: false 
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    //,autoHeight: true
	    ,autoWidth: true
		,resizable:true
		,monitorResize: true
	    ,style: 'margin-bottom:10px;'
	    ,cls: 'cursor_pointer'
	    ,height: this.height || 150
	    ,collapsible: this.collapsible || false
	    ,animCollapse: this.animCollapse || false
		,border: true
		,doLayout: function() {
			if(this.isVisible()){
				var margin = 10;
				var parentSize = app.contenido.getSize(true);
				var width = (parentSize.width) - (2*margin);
				this.setWidth(width);
				Ext.grid.GridPanel.prototype.doLayout.call(this);
			}
		  }
    };

    if(this.collapsible) {
    	config.plugins = expander;
    }


    Ext.apply(this, config);
    Ext.apply(this.initialConfig, config);

    Ext.ux.DynamicGridPanel.superclass.initComponent.apply(this, arguments);
  },

  getRowClass:function(record, rowIndex, p, store) {
	    p.body = record.get('rowbody');
	    return p.body ? 'x-grid3-row-with-body' : '';
	  },

  onRender: function(ct, position){
    this.colModel.defaultSortable = false;

    Ext.ux.DynamicGridPanel.superclass.onRender.call(this, ct, position);

    /**
     * Grid is not masked for the first data load.
     * We are masking it while store is loading data
     */
    this.store.on('metachange', function(){
      /**
       * Thats the magic! <img src="http://erhanabay.com/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley">
       *
       * JSON data returned from server has the column definitions
       */
      if(typeof(this.store.reader.jsonData.columns) === 'object') {
	      var columns = [];

	      /**
	       * Adding RowNumberer or setting selection model as CheckboxSelectionModel
	       * We need to add them before other columns to display first
	       */
	      if(this.rowNumberer) { columns.push(new Ext.grid.RowNumberer()); }
	      if(this.checkboxSelModel) { columns.push(new Ext.grid.CheckboxSelectionModel()); }
	      if(this.collapsible) { columns.push(expander); }

        Ext.each(this.store.reader.jsonData.columns, function(column){
          columns.push(column);
        });

	      /**
	       * Setting column model configuration
	       */
	      this.getColumnModel().setConfig(columns);
      }
      /**
       * Unmasking grid
       */
      this.el.unmask();
    }, this);


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
	            if (cell===false) return;
	            var field = this.getColumnModel().config[cell].dataIndex;

	            var rowData = this.getView().getCell(row,cell);
	            rowData = rowData.innerText? rowData.innerText : rowData.textContent;
	            rowData = rowData.trim();

	            if(rowData != this.lastRowData){
	            	this.fireEvent("beforetooltipshow", this, row, cell, rowData);
	            }
	            this.lastRowData = rowData;
	            if (!rowData) return false;
    		},
    		scope: this
    	}
    });
  },
  listeners: {
	  render: function(g) {
		g.on("beforetooltipshow", function(grid, row, col, rowData) {
				grid.tooltip.body.update(rowData);
		  });
		}
    }
});
