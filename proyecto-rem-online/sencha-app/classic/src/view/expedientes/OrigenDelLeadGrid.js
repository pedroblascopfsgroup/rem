Ext.define('HreRem.view.expedientes.OrigenDelLeadGrid', {
    extend		:  'HreRem.view.common.GridBase',
    xtype		: 'origenDelLeadGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind:{
		store:'{storeOrigenLead}'
	},

	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{
					dataIndex: 'idCombo',
					reference: 'idGridOrigenLead',
		            hidden: true
				},
		        {
		            dataIndex: 'origenCompradorLead',
		            reference: 'canalOrigen',
		            name:'canalOrigen',
		            text: HreRem.i18n('fieldlabel.canal.origen.lead'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'proveedorPrescriptorLead',
		            reference: 'prescriptorLead',
		            name:'prescriptorLead',
		            text: HreRem.i18n('fieldlabel.nombre.prescriptor.lead'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'proveedorRealizadorLead',
		            reference: 'realizadorLead',
		            name:'realizadorLead',
		            text: HreRem.i18n('fieldlabel.nombre.proveedor.lead'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'fechaAltaLead',
		            reference: 'fechaAlta',
		            name:'fechaAlta',
		            text: HreRem.i18n('fieldlabel.fecha.alta.lead'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'fechaAsignacionRealizadorLead',
		            reference: 'fechaAsignacionRealizador',
		            name:'fechaAsignacionRealizador',
		            text: HreRem.i18n('fieldlabel.fecha.asignacion.lead.realizador'),
		            flex: 0.7

		        }
		    ];
		
		  me.dockedItems = [
		        {
		        	 xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeOrigenLead}'
			            }
		        }
		];




		    me.callParent();
    }
});
