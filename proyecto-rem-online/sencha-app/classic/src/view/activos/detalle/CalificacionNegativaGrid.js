Ext.define('HreRem.view.activos.detalle.CalificacionNegativaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'calificacionnegativagrid',
	topBar		: true,
	propagationButton: true,
	targetGrid	: 'calificacionNegativa',
	idPrincipal : 'idMotivo',
	idSecundaria: 'activo.id',
	editOnSelect: true,
	disabledDeleteBtn: false,
    bind: {
        store: '{storeCalifiacionNegativa}' // TODO hay que hacerse un store y en ese store apuntar a los model
    },

    initComponent: function () {
    	
     	var me = this;

		me.columns = [
				{
					text: 'id calificacion negativa',
					dataIndex: 'idMotivo',
					hidden: true,
					hideable: false
				},
				{
					text: 'Id Activo',
					dataIndex: 'idActivo',
					hidden: true,
					hideable: false
				},
		        {
		            dataIndex: 'motivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.motivo'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'motivosCalificacionNegativa'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		           
		        },
		        {
		            dataIndex: 'estadoMotivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.estadomotivo.calificacion'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'estadoMotivoCalificacionNegativa'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		            
		        },
		        {
		            dataIndex: 'responsableSubsanar',
		            text: HreRem.i18n('fieldlabel.calificacion.responsablesubsanar'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'responsableSubsanar'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaSubsanacion',
		            text: HreRem.i18n('fieldlabel.calificacion.fechaSubsanacion'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'descripcionCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.descripcion'),
		            editor: {
		        		xtype: 'textareafield'
		        	},
		            flex: 1
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
		                store: '{storeCalifiacionNegativa}'
		            }
		        }
		    ];

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informecomercialactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
   }
});
