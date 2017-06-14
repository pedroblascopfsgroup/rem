Ext.define('HreRem.view.expedientes.ActivosExpediente', {
	extend: 'Ext.panel.Panel',
    xtype: 'activosexpediente', 
    cls	: 'panel-base shadow-panel',
    requires: ['HreRem.view.expedientes.ActivoExpedienteTabPanel'],
    collapsed: false,
    reference: 'activosexpedienteref',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
    	
    	var estadoRenderer =  function(value) {
        	var src = '',
        	alt = '';
        	
        	if (value=="1") {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        	} else { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        	} 

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        }; 
        
        

        var me = this;        
        me.setTitle(HreRem.i18n('title.publicaciones.activos.grid'));		         
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    minHeight	: 150,
			    idPrincipal : 'expediente.id',
			    reference: 'listadoactivos',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeActivosExpediente}'
				},
				
				features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
				}],
				listeners : {
			    	rowclick: 'onRowClickListadoactivos'
			    },
				columns: [
				   {    xtype: 'actioncolumn',
	    			text: HreRem.i18n('fieldlabel.numero.activo'),
		        	dataIndex: 'numActivo',
			        items: [{
			            tooltip: HreRem.i18n('fieldlabel.ver.activo'),
			            getClass: function(v, metadata, record ) {
			            	return "app-list-ico ico-ver-activov2";
			            				            	
			            },
			            handler: 'onEnlaceActivosClick'
			        }],
			        renderer: function(value, metadata, record) {
			        		return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	
			        },
		            flex     : 1,            
		            align: 'left',
		            menuDisabled: true,
		            hideable: false
			       },
				   {
			            text: HreRem.i18n("fieldlabel.subtipo.activo"),
			            dataIndex: 'subtipoActivo',
			            flex:1
			            
			       },
			       {
			            text: HreRem.i18n("fieldlabel.municipio"),
			            dataIndex: 'municipio',
			            flex:1
			            
			       },
			       {
			            text: HreRem.i18n("header.direccion"),
			            dataIndex: 'direccion',
			            flex:1
			            
			       },
			       {
			            text: HreRem.i18n("header.importe.participacion"),
			            dataIndex: 'importeParticipacion',
			            flex:1,
			       		renderer: Utils.rendererCurrency
			       },
			       {   
			       		text: HreRem.i18n("header.porcentaje.participacion"),
			       	    dataIndex: 'porcentajeParticipacion',
			       	    editor: 'textfield',
			       		flex:1,
			       		renderer: function(value) {
			            	return Ext.util.Format.number(value, '0.00%');
			            },
			       		summaryType: 'sum',
			            summaryRenderer: function(value, summaryData, dataIndex) {
			            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value + "%";
			            	var style = "" 
			            	if(value != 100) {
			            		msg = HreRem.i18n("fieldlabel.participacion.total.error")	
			            		style = "style= 'color: red'" 
			            	}			            	
			            	return "<span "+style+ ">"+msg+"</span>"
			            }
			       },
			       {   
			       		text: HreRem.i18n("header.precio.minimo.autorizado"),
			       	    dataIndex: 'precioMinimo',
			       		flex:1,
			       		renderer: Utils.rendererCurrency
			       },
			       {   
			       		text: HreRem.i18n("title.condiciones"),
			       		renderer: estadoRenderer,	           
			            flex: 0.5,
			            dataIndex: 'condiciones',
			            align: 'center'
			       },
			       {   
			       		text: HreRem.i18n("title.bloqueos"),
			       		renderer: estadoRenderer,	           
			            flex: 0.5,
			            dataIndex: 'bloqueos',
			            align: 'center'
			       },
			       {   
			       		text: HreRem.i18n("title.tanteo"),
			       		renderer: estadoRenderer,	           
			            flex: 0.5,
			            dataIndex: 'tanteos',
			            align: 'center'
			       }
			       	        
			    ],
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeActivosExpediente}'
			            }
			        }
			    ]
			    
			},
			{
		        xtype: 'splitter',
		        cls: 'x-splitter-base',
		        collapsible: true
		    },
			{	
				xtype: 'activoExpedienteTabPanel',
				reference: 'activoExpedienteMain',
				collapsed: false,
				hidden: true,
				flex: 1
			}
			//HREOS-2222  
            
            
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    	
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.mask();
  			grid.getStore().load({callback: function() {grid.unmask();}});
  		});	
    }
    
});