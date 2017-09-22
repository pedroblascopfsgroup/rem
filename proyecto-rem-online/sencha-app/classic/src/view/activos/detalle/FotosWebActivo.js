Ext.define('HreRem.view.activos.detalle.FotosWebActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fotoswebactivo',    
    frame: true,
    collapsible: true,
    layout: 'column',
    scrollable	: 'y',
    title: 'Fotos Web',
    listeners: {
    	beforerender:'cargarTabFotos',
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
				store: '{storeFotos}'
			},
        	
            multiSelect: true,
            width: '67%',
            height: '100%',
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
                    this.up('panel').setTitle('Fotos Web (' + l + ' item' + s + ' seleccionado' +  s + ')');
                },
                itemclick: function(dataview,record) {
                	if (record.getData().principal ==  true || record.getData().principal == "true") {
                		this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].show();
                		this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].show();
                		
                		if(record.getData().interiorExterior== "true" && !this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].getValue()){
                			this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].setValue(true);
                		}
                		if(record.getData().interiorExterior== "false" && !this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].getValue()){
                			this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].setValue(true);
                		}
                	} else {
                		this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].hide();
                		this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].hide();
                	}
                	Ext.global.console.log(record.data);
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
					 		name: 'id',
					 		xtype: 'textfieldbase',
					 		bind: {value: '{id}',hidden:true},
							fieldLabel:  "id"
						},
		                { 
		                	name: 'nombre',
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
		                	bind: {
								value: '{nombre}'
							}
		                },
		                { 
		                	xtype: 'textareafieldbase',
		                	name: 'descripcion',
		                	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
		                	bind: {
								value: '{descripcion}'
							}
		                },
		                { 
		                	xtype: 'datefieldbase',
		                	name: 'fechaDocumento',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
		                	bind:		'{fechaDocumento}'
		                },
		                { 
		                	name: 'orden',
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.orden.publicacion.web'),
		                	bind:		'{orden}'
		                		
		                },
		                { 
		                	name: 'principal',
		                	xtype : 'checkboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.principal'),
		                	bind:		'{principal}',
		                	listeners:{
		                		change: function(checkbox, newValue, oldValue, eOpts) {
		                			if(newValue){
		                				this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].show();
		                				this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].show();
		                			}else{
		                				this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[0].hide();
		                				this.up('form').down('fieldcontainer[reference=radiogroupinterior]').items.items[1].hide();
		                			}
		                		}
		                	}
		                },
		                {
		                	name: 'interiorExterior',
		                	xtype: 'radiogroup',
		                    reference: 'radiogroupinterior',
		                    bind: {
		                    	value: '{radioValue}'
		                    },
		                    viewModel: {
			                   formulas: {
			                        radioValue: {
			                            bind: '{interiorExterior}',
			                            get: function(value) {
			                            	if (value == 'true' || value == true) {
			                            		return {
			                                   	 interiorExterior: true
			                                	}; 
			                            	} else {
			                            		return {
			                                    	interiorExterior: false
			                                	};
			                            	}
			                               
			                            }
//			                            set: function(value) {
//			                            	// FIXME: Mirar para cancelar cuando esté habilitado el modo edición
//			                                this.set('interiorExterior', value.interiorExterior);
//			                            }
			                        }
				               	}
			                },

		                    items: [
			                    {
			                    	hidden: true,
			                    	plugins		: {ptype: 'UxReadOnlyEditField'},	
									edicionGeneral: true,
			                        boxLabel: 'Interior',
			                        name: 'interiorExterior',
			                        inputValue: true,
			                        width: 100
			                    },
			                    {
			                    	hidden: true,
			                    	plugins		: {ptype: 'UxReadOnlyEditField'},	
									edicionGeneral: true,
			                        boxLabel: 'Exterior',
			                        name: 'interiorExterior',
			                        inputValue: false,
			                        width: 100
			                    }
			                ]
		                }
		                
		            ]
			}
		],

		me.dockedItems = [{
		    xtype: 'toolbar',
		    buttonAlign: 'left',
		    dock: 'top',
		    items: [
			    //Desactivado para fase 1
			   	{ iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddFotoClick', secFunPermToEnable: 'EDITAR_TAB_FOTOS_ACTIVO_WEB'},
			    { iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onDeleteFotoClick', secFunPermToEnable: 'EDITAR_TAB_FOTOS_ACTIVO_WEB'},
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
    	if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			//me.down('[xtype=toolbar]').hide();
			allowEdit = false;
		}
    	if(allowEdit && me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
 	    	allowEdit = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
 	    			&& $AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_WEB'));
 	    }
    	if(!allowEdit){
    		me.down('[xtype=toolbar]').hide();
    	}
    }
});