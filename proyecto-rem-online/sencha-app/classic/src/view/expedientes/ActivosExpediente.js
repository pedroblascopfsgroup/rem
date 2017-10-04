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
    	
    	
    	
        var condicionesRenderer =  function(value) {
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
        var tanteosRenderer =  function(value) {
        	var src = '',
        	alt = '';
        	if (value=="1") {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(value=="0") { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(value=="2") { 
        		return '<b style=\"color:red\">EJERCIDO</b>'
        	} else if(value=="3") { 
        		return 'N/A'
        	}   
        }; 
        var bloqueosRenderer =  function(value) {
        	var src = '',
        	alt = '';
        	if (value=="1") {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(value=="0") { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(value=="2") { 
        		return 'PENDIENTE'
        	}   
        }; 
                
        

        var me = this;        
        me.setTitle(HreRem.i18n('title.publicaciones.activos.grid'));		         
        var items= [
			{   
				xtype:'fieldset',
				collapsible: false,
				border: false,
				defaultType: 'displayfieldbase',
				cls	: 'panel-base shadow-panel',
				items : [
					{
						
			            	xtype: 'button',
			            	reference: 'btnGenerarHojaExcelActivos',
			            	bind: {
			            		disabled: '{!resolucion.generacionHojaDatos}'
			            	},
			            	text: HreRem.i18n('title.activo.administracion.exportar.excel'),
			            	handler: 'onClickGenerarHojaExcelActivos',
			            	margin: '10 10 10 10'
			            
					}
					]
			},
			{
			    xtype		: 'gridBaseEditableRow',
			    minHeight	: 200,
			    idPrincipal : 'expediente.id',
			    reference: 'listadoactivosexpediente',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeActivosExpediente}'
				},
//				saveSuccessFn: function() {
//					this.lookupController().refrescarExpediente(true);
//				},
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
			            editor:  'textfield',			            
			            flex:1,
			       		renderer: Utils.rendererCurrency,
			       		summaryType: function(){
							
							var store = this;
		                    var records = store.getData().items;
		                    var field = ['importeParticipacion'];
		                    function Suma(record, field) {
		                        var total = 0;
		                        var j = 0,
		                        lenn = record.length;
		                        for (; j < lenn; ++j) {

		                           total = total + (parseFloat(record[j].get(field))*100);
		                        }
		                        return total/100;
		                    };
		                    if (this.isGrouped()) {
		                        var groups = this.getGroups();
		                        var i = 0;
		                        var len = groups.length;
		                        var out = {},
		                        group;
		                        for (; i < len; i++) {
		                            group = groups[i];
		                            out[group.name] = Suma.apply(store, [group.children].concat(field));
		                        }
		                        var groupSum = out[groups[w].name];
		                        w++;
		                        return groupSum;
		                    } else {
		                        return Suma.apply(store, [records].concat(field));
		                    }
						},
			            summaryRenderer: function(value, summaryData, dataIndex) {		
			            	value = parseFloat(value);
			            	var msg = HreRem.i18n("fieldlabel.importe.participacion.igual")
			            	var style = ""
			            	if(value != parseFloat(this.lookupController().getViewModel().get('expediente.importe'))) {
			            		msg = HreRem.i18n("fieldlabel.importe.participacion.desigual") + " " + 
			            			(value*100 - (this.lookupController().getViewModel().get('expediente.importe'))*100)/100 + "&euro;"
			            		style = "style= 'color: red'"
			            	}
			            	
			            	return "<span "+style+ ">"+msg+"</span>"
			            }
			            
			       },
			       {   
			       		text: HreRem.i18n("header.porcentaje.participacion"),
			       	    dataIndex: 'porcentajeParticipacion',
			       	    //editor: 'textfield',
			       		flex:1,
			       		renderer: function(value) {
			            	return Ext.util.Format.number(value, '0.00%');
			            }//,
//			       		summaryType: 'sum',
//			            summaryRenderer: function(value, summaryData, dataIndex) {
//			            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value + "%";
//			            	var style = "";
//			            	if(value != 100) {
//			            		msg = HreRem.i18n("fieldlabel.participacion.total.error");	
//			            		style = "style= 'color: red'";
//			            	}			            	
//			            	return "<span "+style+ ">"+msg+"</span>";
//			            }
			       },
			       {   
			       		text: HreRem.i18n("header.precio.minimo.autorizado"),
			       	    dataIndex: 'precioMinimo',
			       		flex:1,
			       		renderer: Utils.rendererCurrency,
			       		summaryType: 'sum',
			            summaryRenderer: function(value, summaryData, dataIndex) {			            	
			            	var suma= 0;
			            	var store = this.up('gridBaseEditableRow').getStore();
			            	for(var i=0; i< store.data.length; i++){	            		
			            		if(store.data.items[i].data.precioMinimo != null){
			            			suma += parseFloat(store.data.items[i].data.precioMinimo);
			            		}
		            		}
			            	var msg = HreRem.i18n("fieldlabel.precio.minimo.autorizado.total")+": "+Ext.util.Format.currency(suma);
			            	return "<span>"+msg+"</span>"
			            }
			       },
			       {   
			       		text: HreRem.i18n("title.condiciones"),
			       		renderer: condicionesRenderer,	           
			            flex: 0.5,
			            dataIndex: 'condiciones',
			            align: 'center'
			       },
			       {   
			       		text: HreRem.i18n("title.bloqueos"),
			       		renderer: bloqueosRenderer,	           
			            flex: 0.5,
			            dataIndex: 'bloqueos',
			            align: 'center'
			       },
			       {   
			       		text: HreRem.i18n("title.tanteo"),
			       		renderer: tanteosRenderer,	           
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
				minHeight	: 350
			}
			//HREOS-2222  
            
            
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    	
    },
    actualizarTabActivoExpediente: function(){
    	me.funcionRecargar();
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
			if(grid != undefined){
				grid.getStore().load();
			}
  		});		
    }
    
});