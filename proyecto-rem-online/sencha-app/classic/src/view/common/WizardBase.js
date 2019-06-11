Ext.define('HreRem.view.common.WizardBase', {
	extend: 'HreRem.view.common.WindowBase',
	xtype: 'wizardBase',
	bodyPadding: '5',
	layout: 'card',

	listeners: {
		boxready: function (window) {
			new Ext.KeyMap(window.getEl(), {
				key: Ext.event.Event.ESC,
				fn: function (event, node) {
					if(window.closable) {
						window.close();
					}
				},
				scope: window
			});
		}
	},

	items: [],

	slides: [],

	/**
	 * Constructor de la ventana de tipo wizard.
	 */
	initComponent: function() {
		var me = this;

		me.items = [];
		me.fillItemsWithSlides();
		me.callParent();
	},

	/**
	 * Este método rellena el listado de elementos de la ventana tipo Wizard con
	 * objetos creados a partir del xtype declarado en el Array de 'slides'.
	 */
	fillItemsWithSlides: function() {
		var me = this;

		Ext.Array.each(me.slides, function(slideXtype) {
			me.items.push({
				xtype: slideXtype
			});
		});
	},

	/**
	 * Este método oculta la ventana de tipo wizard sin destruir su contenido, haciendolo reutilizable más rápidamente.
	 * Se puede especificar si antes de ocultar el wizard se reinicia el contenido de los slides. Esta acción funciona
	 * con slides que son de tipo formulario.
	 * 
	 * @param {boolean} resetSlides : True para reestablecer el contenido de los slides. False para sólo ocultar el wizard.
	 */
	hideWizard: function(resetSlides) {
		var me = this;

		if (!Ext.isEmpty(resetSlides)) {
			Ext.Array.each(me.items.items, function(item) {
				if (Ext.isDefined(item.getForm)) {
					item.reset();
				}
			});
		}

		!Ext.isEmpty(me.items.items) ? me.setActiveItem(0) : undefined;

		me.hideWindow();
	},

	/**
	 * Este método avanza, si existe un slide posterior al actual, entre los slides asignados al wizard.
	 * Si no existe ningún otro slide al que avanzar, cierra la ventana. Esto prepara el método como único
	 * punto estándar centralizado de avance.
	 */
	nextSlide: function() {
		var me = this;

		me.getLayout().getNext() ? me.getLayout().next() : me.closeWindow();
	},

	/**
	 * Este método retrocede, si existe un slide anterior al actual, entre los slides asignados al wizard.
	 */
	previousSlide: function() {
		var me = this;

		me.getLayout().getPrev() ? me.getLayout().prev() : undefined;
	}

});