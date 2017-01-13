Ext.define('HreRem.view.agrupaciones.detalle.FotosSubdivision', {
    extend: 'HreRem.view.common.FormBase',
    dataViewAlternativo: 'imageDataViewSubdivision',
    idEntidadToLoad: true,
    //extend: 'Ext.panel.Panel',
    xtype: 'fotossubdivision',    
    frame: true,
    collapsible: true,
    //isSearchForm: true,
    layout: 'column',
    scrollable	: 'y',
    //title: HreRem.i18n('title.fotos.subdivision'),
    listeners: {
    	//beforerender:'cargarTabFotos',
    	afterrender: function() { 
    		var me = this;
    		$AU.confirmFunToFunctionExecution(function(){me.dragDrop();},"EDITAR_FOTOS_SUBDIVISION")    		
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
        
        me.setTitle(HreRem.i18n('title.fotos'));
        
        var imageTemplate = new Ext.XTemplate('<tpl for=".">',
        	'<div class="thumb-wrap" id="{nombre}">',
        	'<span>&nbsp;{tituloFoto}</span>',
      		'<div class="thumb"> <img src="'+$AC.getRemoteUrl("activo/getFotoActivoById")+'?idFoto={id}" title="{subdivisionDescripcion}"></div>',
         	'<span>{nombre} Orden: {orden} </span></div>',
      		'</tpl>');

        // DataView for the Gallery
        var imageDataView =  Ext.create('Ext.view.View',{
        	tpl: imageTemplate,
        	cls: 'images-view',
        	reference: 'imageDataViewSubdivision',
           	bind: {
				store: '{storeFotosSubdivision}'
			},
        	
            multiSelect: true,
            width: '67%',
            height: '100%',
            scrollable	: 'y',
            trackOver: true,
            overItemCls: 'x-item-over',
            itemSelector: 'div.thumb-wrap',
            emptyText: HreRem.i18n('fieldlabel.sin.imagenes'),
            listeners: {
                selectionchange: function(dv, nodes ){
                    var l = nodes.length,
                        s = l !== 1 ? 's' : '';
                    this.up('panel').setTitle('Fotos (' + l + ' item' + s + ' seleccionado' +  s + ')');
                },
                itemclick: function(dataview,record) {
	        		this.up('form').setBindRecord(record.data);
	        	}
            }
        });
        
        $AU.confirmFunToFunctionExecution(function(){imageDataView.plugins = [Ext.create('Ext.ux.DataView.DragSelector', {}),Ext.create('Ext.ux.DataView.LabelEditor', {dataIndex: 'nombre'})]},"EDITAR_FOTOS_SUBDIVISION")
        
        

        me.items= [
			
			imageDataView,
			{
				xtype:'fieldset',
				margin: '0 0 0 20',
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
							name: 'id',
							xtype: 'textfieldbase',
							bind: {value: '{id}',hidden:true}
						},
		                { 
							name: 'nombre',
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
		                	bind: {
								value: '{nombre}'
							}
		                },
		                { 
		                	name: 'descripcion',
		                	xtype: 'textareafieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
		                	bind: {
								value: '{descripcion}'
							}
		                },
		                { 
		                	name: 'fechaDocumento',
		                	xtype: 'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
		                	bind:		'{fechaDocumento}'
		                },
		                { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.orden.publicacion.web'),
		                	bind:		'{orden}',
		                	xtype: 'displayfieldbase'
		                }
		               
		                
		            ]
			}

			
		],
		
		me.dockedItems = [{
		    xtype: 'toolbar',
		    buttonAlign: 'left',
		    dock: 'top',
		    height: 50,
		    items: [
		        { iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddFotoSubdivisionClick',  bind: {hidden: '{existeFechaBaja}'}, secFunPermToEnable: 'EDITAR_FOTOS_SUBDIVISION'},
		        { iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onDeleteFotoClick',  bind: {hidden: '{existeFechaBaja}'}, secFunPermToEnable: 'EDITAR_FOTOS_SUBDIVISION'},
		        { iconCls:'x-fa fa-download', itemId:'downloadButton', handler: 'onDownloadFotoClick', secFunPermToEnable: 'EDITAR_FOTOS_SUBDIVISION'},
		        { 
		        	xtype: 'combobox',
		        	editable: false,
		        	fieldLabel: HreRem.i18n('fieldlabel.subdivision'),
		        	width: 		400,
					reference: 'tipoSubdivisionCombo',
		        	bind: {
	            		store: '{storeSubdivisiones}'
	            	},
	            	listeners: {
	            		select: function(combo, record) {
				    		me.fireEvent('cargarFotosSubdivision', record);
				    	}
	            	},
	            	displayField: 'descripcion',
					valueField: 'id'
		        }
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

	},
	
	funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		var subdivisionSelected = me.down('[reference=tipoSubdivisionCombo]').getSelection();
		
		if(!Ext.isEmpty(subdivisionSelected)) {
			me.fireEvent('cargarFotosSubdivision', subdivisionSelected);			
		}
		
		
    }
    
});