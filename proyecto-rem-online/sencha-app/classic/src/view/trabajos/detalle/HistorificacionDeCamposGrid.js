Ext.define('HreRem.view.trabajos.detalle.HistorificacionDeCamposGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'historificacioncamposgrid',
	topBar		: false,
	targetGrid	: 'historificacionCampos',
	editOnSelect: false,
	disabledDeleteBtn: true,
	sortableColumns: false,
	idTrabajo: null,
	codigoPestanya: null,
	controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    bind: {
        store: '{storeHistorificacionDeCampos}' 
    },
    requires: ['HreRem.view.trabajos.detalle.TrabajoDetalleController', 'HreRem.model.HistoricoDeCamposModel'],

    initComponent: function () {
    	
     	var me = this;
     	
     	
     	me.columns = [
				{
					text: 'Id Trabajo',
					dataIndex: 'idTrabajo',
					hidden: true,
					editor: {
		        		xtype: 'textareafield'
	        			}
				},
		        {
		            dataIndex: 'campo',
		            reference: 'campo',
		            text: HreRem.i18n('fieldlabel.historificacion.campos.campo'),
		            editor: 
		            	{
							xtype: 'textareafield'								        		
						},
		            flex: 1
		        },
		        {
		            dataIndex: 'usuarioModificacion',
		            reference: 'usuarioModificacion',
		            text: HreRem.i18n('fieldlabel.historificacion.campos.usuario.modificacion'),
		            editor: 
		            	{
							xtype: 'textareafield'								        		
						},
					editable:false,	
		            flex: 1
		        },
		        
		        
		        {
		            dataIndex: 'fechaModificacion',
		            text: HreRem.i18n('fieldlabel.historificacion.campos.fecha.modificacion'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'valorAnterior',
		            reference: 'valorAnterior',
		            text: HreRem.i18n('fieldlabel.historificacion.campos.valor.anterior'),
		            editor: 
		            	{
							xtype: 'textareafield'								        		
						},
		            flex: 1
		        },
		        {
		            dataIndex: 'valorNuevo',
		            reference: 'valorNuevo',
		            text: HreRem.i18n('fieldlabel.historificacion.campos.valor.nuevo'),
		            editor: 
		            	{
							xtype: 'textareafield'								        		
						},
		            flex: 1
		        }
		    ];

		
		
		     me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistorificacionDeCampos}' 
		            }
		        }
		    ];
		    
    		me.lookupController().cargarStoreHistoricoDeCampos(me);	

			
		    me.callParent(); 
	        
	
   }
   
   

		   
});
