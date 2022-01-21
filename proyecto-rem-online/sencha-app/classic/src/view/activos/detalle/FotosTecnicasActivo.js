Ext.define('HreRem.view.activos.detalle.FotosTecnicasActivo', {
    extend: 'HreRem.view.common.FormBase',
    //extend: 'Ext.panel.Panel',
    xtype: 'fotostecnicasactivo',    
    frame: true,
    collapsible: true,
    //isSearchForm: true,
    recordName: 'fotoWeb',
    layout: 'column',
    scrollable	: 'y',
    title: 'Fotos Técnicas',
    listeners: {
    	afterrender: function() {
    		this.dragDrop();
    	},
    	boxready: function (tabPanel) { 
    		tabPanel.evaluarEdicion();
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
        var visibilidadBotonesEdicion = me.lookupController().getVisiblityOfBotons();
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
        	reference: 'imageDataViewTecnicas',
           	bind: {
				store: '{storeFotosTecnicas}'
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
           /* prepareData: function(data) {
                Ext.apply(data, {
                    shortName: Ext.util.Format.ellipsis(data.name, 15),
                    sizeString: Ext.util.Format.fileSize(data.size),
                    dateString: Ext.util.Format.date(data.lastmod, "m/d/Y g:i a")
                });
                return data;
            },*/
            listeners: {
                selectionchange: function(dv, nodes ){
                    var l = nodes.length,
                        s = l !== 1 ? 's' : '';
                    this.up('panel').setTitle('Fotos Técnicas (' + l + ' item' + s + ' seleccionado' +  s + ')');
					if (l < 1){
                		this.up('form').getForm().findField('nombre').setValue();
                		this.up('form').getForm().findField('codigoTipoFoto').setValue();
                		this.up('form').getForm().findField('codigoDescripcionFoto').setValue();
                		this.up('form').getForm().findField('fechaDocumento').setValue();
						this.up('form').getForm().findField('orden').setValue();
					}
                },
                itemclick: function(dataview,record) {
                	if(Ext.isEmpty(record.getData().nombre)){
                		this.up('form').getForm().findField('nombre').setValue();
                	}
					if(Ext.isEmpty(record.getData().codigoTipoFoto)){
                		this.up('form').getForm().findField('codigoTipoFoto').setValue();
                	}
                	if(Ext.isEmpty(record.getData().codigoDescripcionFoto)){
                		this.up('form').getForm().findField('codigoDescripcionFoto').setValue();
                	}
                	if(Ext.isEmpty(record.getData().fechaDocumento)){
                		this.up('form').getForm().findField('fechaDocumento').setValue();
                	}
	        		this.up('form').setBindRecord(record.data);
	        		this.lookupController().getViewModel().set('fotoSelected', record);
	        		this.lookupController().getViewModel().notify();
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
								name: 'id',
								xtype: 'textfieldbase',
								bind: {value: '{fotoWeb.id}',hidden:true},
								fieldLabel:  "id"
						},
		                { 
							name: 'nombre',
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
		                	bind: {
								value: '{fotoWeb.nombre}'
							}
		                },
						{ 
		                	xtype: 'comboboxfieldbase',
		                	name: 'codigoTipoFoto',
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
		                	editable: false,
		                	queryMode: 'local',
		                	bind: {
		                		store: '{storeTipoFoto}',
				        		value: '{fotoWeb.codigoTipoFoto}'
							},
							allowBlank: false
		                },
		                { 
		                	name: 'codigoDescripcionFoto',
		                	xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
		                	editable: false,
		                	queryMode: 'local',
		                	bind: {
		                		store: '{storeDescripcionFoto}',
				        		value: '{fotoWeb.codigoDescripcionFoto}'
							},
							allowBlank: false
		                },
		                { 
		                	name: 'fechaDocumento',
		                	xtype: 'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
		                	bind:		'{fotoWeb.fechaDocumento}'
		                },
		                { 
		                	name: 'orden',
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.orden.publicacion.web'),
		                	bind:		'{fotoWeb.orden}'
		                }
		                
		            ]
			}

			
		],
		
		me.dockedItems = [{
		    xtype: 'toolbar',
		    buttonAlign: 'left',
		    dock: 'top',
		    items: [
		        { iconCls:'x-fa fa-plus', itemId:'addButton', hidden: visibilidadBotonesEdicion, handler: 'onAddFotoClick', secFunPermToEnable: 'EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'},
		        { iconCls:'x-fa fa-minus', itemId:'removeButton', hidden: visibilidadBotonesEdicion, handler: 'onDeleteFotoClick', secFunPermToEnable: 'EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'},
		        { iconCls:'x-fa fa-download', itemId:'downloadButton', handler: 'onDownloadFotoClick'},
		        { iconCls:'x-tbar-loading', itemId:'reloadButton', handler: 'onReloadFotoClick', secFunPermToEnable: 'EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'}
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
				
				
				/*var ordenFijo = record.data.orden;
				var ordenMovido = data.records[0].data.orden;
				
				data.records[0].data.orden = ordenFijo;
				record.data.orden = ordenMovido;*/
				
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
    
    //HREOS-846 Si NO esta dentro del perimetro, ocultamos las opciones de agregar/eliminar imagenes
    evaluarEdicion: function() {    	
    	var me = this;
		var allowEdit = true;		
    	if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false" || me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			//me.down('[xtype=toolbar]').hide();
			allowEdit = false;
		}
    	if(allowEdit && me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
 	    	allowEdit = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
 	    			&& $AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'));
 	    }
    	if(!allowEdit){
    		me.down('[xtype=toolbar]').hide();
    	}
    }
    
});