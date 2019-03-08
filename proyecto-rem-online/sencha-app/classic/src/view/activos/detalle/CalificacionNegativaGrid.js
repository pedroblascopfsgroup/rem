Ext.define('HreRem.view.activos.detalle.CalificacionNegativaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'calificacionnegativagrid',
	topBar		: true,
	propagationButton: true,
	targetGrid	: 'calificacionNegativa',
	idPrincipal : 'activo.id',
	editOnSelect: false,
	disabledDeleteBtn: true,
    bind: {
        store: '{storeHistoricoMediador}' // TODO hay que hacerse un store y en ese store apuntar a los model
    },

    initComponent: function () {

     	var me = this;

		me.columns = [
		        {
		            dataIndex: 'motivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.motivo'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'estadoMotivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.estadomotivo.calificacion'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaSubsanacion',
		            text: HreRem.i18n('fieldlabel.calificacion.fechaSubsanacion'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'responsableSubsanar',
		            text: HreRem.i18n('fieldlabel.calificacion.responsablesubsanar'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'descripcionCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.descripcion'),
		            flex: 0.5
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
		                store: '{storeHistoricoMediador}'
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
