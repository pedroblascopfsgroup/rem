Ext.define('HreRem.view.expedientes.ExpedienteDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'expedientedetallemain',
	iconCls		: 'fa fa-folder-open',
	iconAlign	: 'left',
	controller	: 'expedientedetalle',
    viewModel	: {
        type: 'expedientedetalle'
    },
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },
    requires	: ['HreRem.view.expedientes.ExpedienteDetalleController', 'HreRem.view.expedientes.ExpedienteDetalleModel', 
					'HreRem.view.expedientes.CabeceraExpediente', 'HreRem.view.expedientes.ExpedienteDetalle'],

    // NOTA: Añadiendo los items en la función configCmp, y llamando a esta en el callback de la petición de datos del activo, conseguimos que la pestaña se añada casi de inmediato al tabpanel,
	// renderizando el resto de contenido una vez hecha la petición. Se ha añadido un simple container, que posteriormente se quitará, para que la mascará de carga de la pestaña se muestre correctamante

	items: [	
			{xtype: 'container',
			 cls: 'container-mask-background',
			 flex: 1
			}
    ],

    configCmp: function(data) {
    	var me = this;
    	if(me.down('[cls=container-mask-background]')) {
    		me.removeAll();
    		me.add({xtype: 'cabeceraexpediente'});
    		me.add({xtype: 'expedientedetalle', flex: 1});
    	}
    	/**
    	 * La formula que desactiva la pestaña de reserva no actua cuando se renderiza por primera vez el expediente
    	 */
    	var reservaDisabled;
		var bloqueado;
		var tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
		
    	reservaDisabled = !me.getViewModel().get('expediente.tieneReserva') || me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler;

		reservaDisabled = Ext.isDefined(reservaDisabled)? reservaDisabled : true;
		bloqueado = me.getViewModel().get('expediente.bloqueado');
    	me.down('reservaexpediente').setDisabled(reservaDisabled);
		me.down('expedientedetalle').bloquearExpediente(me.down('datosbasicosexpediente'),bloqueado);
		me.down('ofertaexpediente').bloquearExpediente(me.down('ofertaexpediente'),bloqueado);

		// HREOS-4366
		if(me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler){				
			var tabReserva = me.down('reservaexpediente');
			tabReserva.tab.setVisible(false);
		}

		if(me.down('activoExpedienteTabPanel') != undefined){
			me.down('activoExpedienteTabPanel').bloquearExpediente(me.down('activoExpedienteTabPanel'),bloqueado);
		}

		if(!me.getViewModel().get('expediente.definicionOfertaFinalizada')){				
			var tabSeguro= me.down('segurorentasexpediente');
			var tabScoring= me.down('scoringexpediente');
			tabSeguro.tab.setVisible(false);
			tabScoring.tab.setVisible(false);
		}
		
		var tabScoring= me.down('scoringexpediente');
		if(!me.getViewModel().get('expediente.definicionOfertaScoring')){				
			tabScoring.tab.setVisible(false);
		}else{
			tabScoring.tab.setVisible(true);
		}
		
    }
});