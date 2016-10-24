Ext.define('HreRem.view.activos.tramites.DatosGeneralesTramite', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datosgeneralestramite',
    cls	: 'panel-base shadow-panel',
    reference: 'datosgeneralestramiteref',
    title: 'Datos Generales',
    layout: 'form',
    collapsed: false,
    scrollable	: 'y',

	recordName: "tramite",
	
	recordClass: "HreRem.model.Tramite",
    
    requires: ['HreRem.model.Tramite'],
    
    

    
    defaults: {
        layout: 'column',
        defaultType: 'displayfield',
       	width: '100%'
    },
    
    initComponent: function () {

        var me = this;
        //debugger;
        
        me.items= [{
			    	xtype: 'fieldset',
			    	title: 'Tr&aacute;mite',
			    	defaults:{
			    		layout:'column',
			    		width: '50%'
			    	},
			        items: [
			            { 
			            	fieldLabel: 'Tipo Tr&aacute;mite',
				        	bind: '{tramite.tipoTramite}'
			            },{ 
			            	fieldLabel: 'N&ordm; de tr&aacute;mite',
			            	bind: '{tramite.idTramite}'
			            },{ 
			            	fieldLabel: 'Estado',
			            	bind: '{tramite.estado}'
			            },{ 
			            	fieldLabel: 'Fecha Inicio',
			            	bind: '{tramite.fechaInicio}'
			            },{ 
			            	fieldLabel: 'Fecha Fin',
			            	bind: '{tramite.fechaFinalizacion}'
			            },{ 
			            	fieldLabel: 'Tr&aacute;mite Original',
			            	bind: '{tramite.tipoTramitePadre}'
			            }
			        ]
			    },
                {
		    	xtype: 'fieldset',
		    	title: 'Trabajo asociado',
		    	bind: {hidden: '{tramite.tieneEC}'},
		    	defaults:{
		    		layout:'column',
		    		width: '50%'
		    	},
		        items: [
			            {
							fieldLabel: 'Tipo',
							bind: '{tramite.tipoTrabajo}'
						},
						{
							fieldLabel: 'Subtipo',
							bind: '{tramite.subtipoTrabajo}'
						},
						{
							fieldLabel: 'N&ordm; de trabajo',
							bind: '{tramite.numTrabajo}'
						}
		        ]
			    },
                {
		    	xtype: 'fieldset',
		    	title: 'Expediente comercial asociado',
		    	bind: {hidden: '{!tramite.tieneEC}'},
		    	defaults:{
		    		layout:'column',
		    		width: '50%'
		    	},
		        items: [
						{
							fieldLabel: 'Estado',
							bind: '{tramite.descripcionEstadoEC}'
						},
						{
							fieldLabel: 'N&ordm; de Expediente',
							bind: '{tramite.numEC}'
						}
		        ]
			    },
	            {
			    	xtype: 'fieldset',
			    	title: 'Activo / Multi-Activo / Agrupaci&oacute;n',
			    	defaults:{
			    		layout:'column',
			    		width: '50%'
			    	},
			        items: [
							{
								fieldLabel: HreRem.i18n('header.num.activos.tramite'),
								bind:		'{tramite.countActivos}'
							},{
								fieldLabel: HreRem.i18n('fieldlabel.numero.activo.agrupacion.haya'),
					        	bind: {
				            		value:	'{tramite.numActivo}',
				            		hidden: '{!tramite.esMultiActivo}'
				            	}
							},{
								fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
					        	bind: {
				            		value:	'{tramite.tipoActivo}',
				            		hidden: '{!activoInforme.tipoActivoCodigo}'
				            	}
							},{
								fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
					        	bind: {
				            		value:	'{tramite.subtipoActivo}',
				            		hidden: '{!tramite.esMultiActivo}'
				            	}
							},{
								fieldLabel:	HreRem.i18n('fieldlabel.cartera'),
								bind:		'{tramite.cartera}'
							}
			        ]
			    }
			];
    	me.callParent();
    }
});