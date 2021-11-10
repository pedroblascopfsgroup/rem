Ext.define('HreRem.view.gastos.SeleccionTasacionesGastoList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'selecciontasacionesgastolist',
    requires: ['Ext.selection.CheckboxModel', 'HreRem.ux.plugin.PagingSelectionPersistence','HreRem.model.TasacionesGasto'],
	bind: {
		store: '{seleccionTasacionesGasto}'
	},
	loadAfterBind: false,
	scrollable: 'y',
	plugins: 'pagingselectpersist',

	
    initComponent: function () {
     	
     	var me = this;
     	//me.setTitle(HreRem.i18n('title.listado.trabajos'));    	
	    me.removeCls('shadow-panel');
	    me.columns = [
	    	
	        
  				{
	            	text	 : HreRem.i18n('fieldlabel.listado.tasacion.id'),
	                flex	 : 1,
	                dataIndex: 'idTasacion'
	            },                 
		        {
		           	text: HreRem.i18n('fieldlabel.id.activo.haya'),
		            flex	 : 1,
		            dataIndex: 'numActivo'
		        },
		        {   
	            	text	 : HreRem.i18n('header.listado.tasacion.externo.bbva'),
	            	flex: 1,
	                dataIndex: 'idTasacionExt'
			    },
	            {   
	            	text	 : HreRem.i18n('fieldlabel.codigo.firma.tasacion'),
	            	flex: 1,
	                dataIndex: 'codigoFirmaTasacion'
			    },
			    {   
	            	text	 : HreRem.i18n('fieldlabel.fecha.rec.tasacion'),
	            	flex: 1,
	                dataIndex: 'fechaRecepcionTasacion',
			        formatter: 'date("d/m/Y")'					
			    }

	    ];
	    
	    
	     
	    me.selModel = {
          selType: 'checkboxmodel'
      	}; 
      	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            displayInfo: true,
	            bind: {
	                store: '{seleccionTasacionesGasto}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
	    me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		me.fireEvent('persistedsselectionchange', sm, record, e, me, me.getPersistedSelection())
        	}
        });
	    
    },
    
    getPersistedSelection: function() {

    	var me = this;
    	return me.getPlugin('pagingselectpersist').getPersistedSelection(); 

    	
    }
    
});