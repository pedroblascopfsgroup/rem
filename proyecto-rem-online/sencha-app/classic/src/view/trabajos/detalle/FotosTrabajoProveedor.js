Ext.define('HreRem.view.trabajos.detalle.FotosTrabajoProveedor', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fotostrabajoproveedor',    
    frame: true,
    collapsible: true,
    layout: 'column',
    scrollable	: 'y',
    title: 'Fotos del proveedor',
    listeners: {
    	//beforerender:'cargarTabFotos',
    	afterrender: function() {
    		this.dragDrop();
    	}

    },
    
    
    
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.Fotos', 'Ext.ux.DataView.DragSelector','Ext.ux.DataView.LabelEditor'],

    tpl: [
        '<ul>',
        '<tpl for=".">',
        '<li>{name}</li>',
        '</tpl>',
        '</ul>'
    ],

    initComponent: function () {
    	 	
        var me = this;
        
        var imageTemplate = new Ext.XTemplate('<tpl for=".">',
        	'<div class="thumb-wrap" id="{nombre}">',
        	'<span>&nbsp;{tituloFoto}</span>',
      		'<div class="thumb"> <img src="{path}" title="{subdivisionDescripcion}"></div>',
         	'<span>{nombre} Orden: {orden} </span></div>',
      		'</tpl>');

        // DataView for the Gallery
        var imageDataView =  Ext.create('Ext.view.View',{
        	tpl: imageTemplate,
        	cls: 'images-view',
        	reference: 'imageDataView',
           	bind: {
				store: '{storeFotosTrabajoProveedor}'
			},
        	
            multiSelect: true,
            //height: 310,
            width: '67%',
            height: '100%',
            //layout: 'fit',
            scrollable	: 'y',
            trackOver: true,
            overItemCls: 'x-item-over',
            itemSelector: 'div.thumb-wrap',
            emptyText: HreRem.i18n('fieldlabel.sin.imagenes'),
            plugins: [
                Ext.create('Ext.ux.DataView.DragSelector', {}),
                Ext.create('Ext.ux.DataView.LabelEditor', {dataIndex: 'nombre'})
            ],
            
            listeners: {
                selectionchange: function(dv, nodes ){
                    var l = nodes.length,
                        s = l !== 1 ? 's' : '';
                    this.up('panel').setTitle('Fotos del proveedor (' + l + ' item' + s + ' seleccionado' +  s + ')');
                },
                itemdblclick: function(dataview,record) {
	        		this.up('form').setBindRecord(record.data);
	        	}
            }
        });

        me.items= [
			
			imageDataView,
			{
				xtype:'fieldset',
				cls	: 'panel-base shadow-panel',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        trAttrs: {height: '45px', width: '100%'},
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				defaultType: 'textfieldbase',
				width: '25%',
				
				title: HreRem.i18n('title.informacion.imagen'),
				items :
					[
		                { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
		                	bind: {
								value: '{nombre}'
							},
							editable: false
		                },
		                { 
		                	xtype: 'textareafieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
		                	bind: {
								value: '{descripcion}'
							}
		                },
		                { 
		                	xtype: 'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
		                	bind:		'{fechaDocumento}',
		                	editable: false
		                }
		                
		            ]
			}

			
		],
		
		me.dockedItems = [{
		    xtype: 'toolbar',
		    buttonAlign: 'left',
		    dock: 'top',
		    items: [
		        { iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddFotoClick', secFunPermToEnable: 'TRABAJO_FOTOPROV_ADD'},
		        { iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onDeleteFotoClick', secFunPermToEnable: 'TRABAJO_FOTOPROV_ADD'},
		        { iconCls:'x-fa fa-download', itemId:'downloadButton', handler: 'onDownloadFotoClick'}
		        //Se deja planteado para fase 2
		        /*,
		        { iconCls:'x-fa fa-print', itemId:'printButton', handler: 'onPrintFotoClick'}*/
		    ]
		}
		];
		

    	me.callParent();
    	
    },
    
    dragDrop: function() {
    	
    	var me = this;
    	
    	var dragZone = new Ext.view.DragZone({
			view: this.items.items[0],
			ddGroup: 'Fotos',
			dragText: 'Mover'
		});
		
		var dropZone = new Ext.view.DropZone({

			view: this.items.items[0],
			ddGroup: 'Fotos',
			handleNodeDrop : function(data, record, position) {
				/* 
				 * record.data.orden
				 * data.records[0].data.orden
				 */
				
				var view = this.view,
					store = view.getStore(),
					index, records, i, len;
				if (data.copy) {
					records = data.records;
					data.records = [];
					for (i = 0, len = records.length; i < len; i++) {
						data.records.push(records[i].copy(records[i].getId()));
					}
				} else {
					data.view.store.remove(data.records, data.view === view);
				}
				index = store.indexOf(record);
				
				//Comentado por error a veces al arrastar una imagen a la primera posición
				if (position !== 'before') {
					index++;
				}
				store.insert(index, data.records);
				view.getSelectionModel().select(data.records);
				me.fireEvent('updateOrdenFotos', data, record, store);
				
			}
		});

	}
    
});