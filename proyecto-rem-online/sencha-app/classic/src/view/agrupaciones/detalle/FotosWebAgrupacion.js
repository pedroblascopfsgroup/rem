Ext.define('HreRem.view.agrupaciones.detalle.FotosWebAgrupacion', {
    extend: 'HreRem.view.common.FormBase',
    //extend: 'Ext.panel.Panel',
    xtype: 'fotoswebagrupacion',    
    frame: true,
    collapsible: true,
    //isSearchForm: true,
    layout: 'column',
    scrollable	: 'y',
    listeners: {
    	beforerender:'cargarTabFotos'
    },
    
    
    
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.Fotos', 'HreRem.view.common.adjuntos.AdjuntarFotoAgrupacion'],

    tpl: [
        '<ul>',
        '<tpl for=".">',
        '<li>{name}</li>',
        '</tpl>',
        '</ul>'
    ],

    initComponent: function () {
    	 	
        var me = this;
        
        me.setTitle(HreRem.i18n("title.fotos.web"));
        
        var imageTemplate = new Ext.XTemplate('<tpl for=".">',
        	'<div class="thumb-wrap" id="{nombre}">',
        	'<span>&nbsp;{tituloFoto}</span>',
      		'<div class="thumb"> <img src="{path}" title="{subdivisionDescripcion}"></div>',
         	'<span>{nombre}</span></div>',
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
		                	fieldLabel:  HreRem.i18n('fieldlabel.numero.activo'),
		                	reference: 'numeroActivoFoto',
		                	bind: {
								value: '{numeroActivo}',
								hidden: '{esAgrupacionObraNuevaOrAsistida}',
								disabled: '{esAgrupacionObraNuevaOrAsistida}'
							}
		                },
		                { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
		                	bind: {
								value: '{nombre}'
							}
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
		                	bind:		'{fechaDocumento}'
		                }

		            ]
			}

			
		],
		
		me.dockedItems = [{
		    xtype: 'toolbar',
		    buttonAlign: 'left',
		    dock: 'top',
		    items: [
		        { iconCls:'x-fa fa-plus', itemId:'addButton', bind : {hidden: '{hideBotoneraFotosWebAgrupacion}'}, handler: 'onAddFotoClick', secFunPermToEnable: 'EDITAR_AGRUPACION'},
		        { iconCls:'x-fa fa-minus', itemId:'removeButton',bind : {hidden: '{hideBotoneraFotosWebAgrupacion}'}, handler: 'onDeleteFotoClick', secFunPermToEnable: 'EDITAR_AGRUPACION'},
		        { iconCls:'x-fa fa-download', itemId:'downloadButton', handler: 'onDownloadFotoClick', secFunPermToEnable: 'EDITAR_AGRUPACION'}
		    ]
		}
		];
		

    	me.callParent();
    	
    }
    
   
});