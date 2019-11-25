Ext.define('HreRem.view.agrupaciones.detalle.DocumentosAgrupacion', {
	extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'documentosagrupacion',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: false,
	removeButton: true,
	layout: 'fit',
	model:	'HreRem.model.DocumentosAgrupacion',
	controller: 'agrupaciondetalle',
    bind: {
    	store: '{storeDocumentosAgrupacion}'
    },
    initComponent: function () {
        var me = this;
      	function formateador(v) {
      		if (typeof v !== 'string') return v
    		return v.charAt(0).toUpperCase()+v.slice(1).split('/')[0];
    	};
        me.setTitle('Documentos');
			me.columns= [
				{
			        xtype: 'actioncolumn',
			        width: 30,	
			        hideable: false,
			        items: [{
			           	iconCls: 'ico-download',
			           	tooltip: HreRem.i18n("tooltip.download"),
			            handler: function(grid, rowIndex, colIndex) {
			            	
			                var record = grid.getRecord(rowIndex);
			                me.fireEvent("download", me, record);
			                
	            		}
			        }]
	    		},
			   {    text: 'Nombre del documento',
		        	dataIndex: 'nombre',
		        	flex: 2
		       },
		       {    text: 'Tipo',
		        	dataIndex: 'descripcionTipo',
		        	flex: 2
		       },
		       {   
		       		text: 'Descripción',
		       	    dataIndex: 'descripcion',
		       		flex: 2,
		       		editor: {
		       			xtype:'textarea'
		       		}
		       },
		       {    text: 'Tamaño',
		        	dataIndex: 'tamanyo',
		        	flex: 2
		       },
			   {
		            text: 'Fecha subida',
		            dataIndex: 'fechaDocumento',
		            flex: 2//,
		        	//formatter: 'date("d/m/Y")'
		            
		       },
		       {
		       	text: 'Formato',
		       	dataIndex: 'contentType',
		       	renderer: formateador, 
		       	flex: 2		       	
		       },
		       {
		       	text: 'idAdjunto',
		       	dataIndex: 'id',
		       	hidden: true
		       }
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            displayInfo: true,
		            inputItemWidth: 100,
		            bind: {
		                store: '{storeDocumentosAgrupacion}'
		            }
		        }
		    ];

    	me.callParent();
    	
    },
 
    onAddClick: function(btn){
		var me = this;
		var datosAgrupacion = me.up('agrupacionesdetallemain').lookupReference('fichaagrupacionref');
		var idAgrupacion =datosAgrupacion.down('[reference=numAgrupacionRemRef]').getValue();
		var entidad ='agrupacion';
		Ext.create('HreRem.view.agrupaciones.detalle.AnyadirNuevoDocumentoAgrupacion',{idAgrupacion: idAgrupacion, grid:this, entidad: entidad}).show();    

    }
  

});