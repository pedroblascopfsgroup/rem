Ext.define('HreRem.view.expedientes.AuditoriaDesbloqueoGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'auditoriaDesbloqueoGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind:{
		store:'{storeAuditoriaDesbloqueo}'
	},

	listeners: {
		afterrender : function(){
			var me = this;
			var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION'])
				|| $AU.userIsRol(CONST.PERFILES['PERFGCONTROLLER']);
			if(!usuariosValidos){
				/*me.lookupReference("fechaInscripcion").setDisabled(true);*/
				me.setHidden(true);
				me.up().setHidden(true);
			}
		}
	},
	
    initComponent: function () {

     	var me = this;    	
     	
		me.columns = [
				{
					dataIndex: 'idCombo',
					reference: 'idGridAuditoriaDesbloqueo',
		            hidden: true
				},
		        {
		            dataIndex: 'idEco',
		            reference: 'idEco',
		            hidden: true
		    		
		        },
		        {
		            dataIndex: 'idUsuario',
		            reference: 'idUsuario',
		            name:'idUsuario',
		            text: HreRem.i18n('fieldlabel.Usuario.auditoria.desbloqueo'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'fechaDeDesbloqueo',
		            reference: 'fechaDeDesbloqueo',
		            name:'fechaDeDesbloqueo',
		            text: HreRem.i18n('fieldlabel.fechaDesbloqueo.auditoria.desbloqueo'),
		            flex: 0.7
		    		
		        },
		        {
		            dataIndex: 'motivoDeDesbloqueo',
		            reference: 'motivoDeDesbloqueo',
		            name:'motivoDeDesbloqueo',
		            text: HreRem.i18n('fieldlabel.motivoDesbloqueo.auditoria.desbloqueo'),
		            flex: 0.7
		    		
		        }
		    ];
		
		  me.dockedItems = [
		        {
		        	 xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeAuditoriaDesbloqueo}'
			            }
		        }
		];

		    me.callParent();
    }
});
