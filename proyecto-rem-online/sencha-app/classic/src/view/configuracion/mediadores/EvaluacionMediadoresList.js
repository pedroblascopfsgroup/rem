Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadoresList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'evaluacionmediadoreslist',
	reference: 'evaluacionMediadoresList',
	topBar: false,
	idPrincipal : 'id',
	editOnSelect: true,
	disabledDeleteBtn: true,
	
    bind: {
        store: '{listaMediadoresEvaluar}'
    },
    
    listeners : {
    	rowclick: 'onRowClickMediador'
    },
    
    initComponent: function () {
     	var me = this;
     	
        me.setTitle(HreRem.i18n("title.evaluacion.mediadores"));  
      
		var evaluarBtn = {text: HreRem.i18n('title.evaluacion.mediadores.evaluar'), cls:'tbar-grid-button', itemId:'evaluarBtn', handler: 'onClickEvaluar', disabled: false};
		var separador = {xtype: 'tbfill'};
//		var espacio = {xtype: 'tbspacer'};
		
		me.tbar = {
		   	xtype: 'toolbar',
		   	dock: 'top',
		   	items: [separador, evaluarBtn]
		};
   
     	var esTopRendererPropuesto =  function(value) {
        	
        	var src = '',
        	alt = '';
        	
        	if (value == 1) {
        		src = 'ico_favorito_added.svg';
        		alt = 'OK';
        	} else if (value == 0){ 
        		src = 'ico_favorito_ko.png';
        		alt = 'KO';
        	} else {
        		src = 'ico_favorito.svg';
        		alt = 'KO';
        	}

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="18px"></div>';
        }; 

     	var esTopRenderer =  function(value) {
        	
        	var src = '',
        	alt = '';
        	
        	if (value == 1) {
        		src = 'ico_favorito_added.svg';
        		alt = 'OK';
        	} else { 
        		src = 'ico_favorito_off.png';
        		alt = 'KO';
        	} 

        	if (src != '') {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="18px"></div>';
        	} else {
        		return null;
        	}
        }; 

     	var medalRenderer =  function(value) {
        	
        	var src = '';
        	
        	if (value == 'Platino') {
        		src = 'ico_medal_platinum.png';
        		alt = 'OK';
        	}
        	if (value == 'Oro') { 
        		src = 'ico_medal_gold2.png';
        		alt = 'OK';
        	}
        	if (value == 'Plata') { 
        		src = 'ico_medal_silver.png';
        		alt = 'OK';
        	}
        	if (value == 'Bronce') { 
        		src = 'ico_medal_bronze.png';
        		alt = 'OK';
        	}
        	if (value == 'Retirar') { 
        		src = 'ico_medal_remove.png';
        		alt = 'OK';
        	}
        	
        	if (src != '') {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="18px"></div>';
        	} else {
        		return null;
        	} 
        };
        
		me.setTitle(HreRem.i18n("title.evaluacion.mediadores.list"));
		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.evaluacion.mediadores.id'),
		            flex: 0.3,
		            hidden: true
		        },
		        {
		            dataIndex: 'codigoRem',
		            text: HreRem.i18n('header.evaluacion.mediadores.codigoRem'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'nombreApellidos',
		            text: HreRem.i18n('header.evaluacion.mediadores.nombreApellidos'),
		            flex: 2
		        },
		        {
		            dataIndex: 'desProvincia',
		            text: HreRem.i18n('header.evaluacion.mediadores.provincia'),
		            flex: 0.7
		        },
		        {
		            dataIndex: 'desLocalidad',
		            text: HreRem.i18n('header.evaluacion.mediadores.localidad'),
		            flex: 0.7
		        },
		        {
		            dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.evaluacion.mediadores.fechaAlta'),
		            formatter: 'date("d/m/Y")',
		            flex: 0.5
		        },
		        {
		            dataIndex: 'esCustodio',
		            text: HreRem.i18n('header.evaluacion.mediadores.custodio'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'esHomologado',
		            text: HreRem.i18n('header.evaluacion.mediadores.homologado'),
		            flex: 0.3,
		            hidden: true
		        },	
		        {
		            dataIndex: 'desEstadoProveedor',
		            text: HreRem.i18n('header.evaluacion.mediadores.estadoProveedor'),
		            flex: 0.7
		        },
		        {
		            dataIndex: 'desCartera',
		            text: HreRem.i18n('header.evaluacion.mediadores.cartera'),
		            flex: 1,
		            hidden: true
		        },
		        {
		            dataIndex: 'desCalificacion',
		            text: HreRem.i18n('header.evaluacion.mediadores.calificacion'),
		            renderer: medalRenderer,
		            flex: 0.7
		        },
		        {
		            dataIndex: 'esTop',
		            text: HreRem.i18n('header.evaluacion.mediadores.top'),
		            renderer: esTopRenderer,
		            flex: 0.3
		        },
		        {
		            dataIndex: 'desCalificacionPropuesta',
		            text: HreRem.i18n('header.evaluacion.mediadores.calificacionPropuesta'),
		            editor: {
			            xtype: 'comboboxfieldbase',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            editable: true,
			            addUxReadOnlyEditFieldPlugin: false,
			            bind: {
			            	store: '{comboCalificacionProveedorConRetirar}'
			            }
			        },
			        renderer: medalRenderer,
		            flex: 0.7
		        },
		        {
		            dataIndex: 'esTopPropuesto',
		            text: HreRem.i18n('header.evaluacion.mediadores.topPropuesto'),
		            editor: {
			            xtype: 'comboboxfieldbase',
			            addUxReadOnlyEditFieldPlugin: false,
			            bind: {
			            	store: '{comboSiNo}'
			            }
		            },
					renderer: esTopRendererPropuesto,
		            flex: 0.3
		        }	
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{listaMediadoresEvaluar}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   }

});