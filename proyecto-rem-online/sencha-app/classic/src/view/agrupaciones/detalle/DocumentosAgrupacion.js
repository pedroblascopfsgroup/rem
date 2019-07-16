Ext.define('HreRem.view.agrupaciones.detalle.DocumentosAgrupacion', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'documentosagrupacion',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: false,
	removeButton: true,
	layout: 'fit',
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.DocumentosAgrupacion'],

    initComponent: function () {

        var me = this;
        me.setTitle('Documentos');
				me.columns= [
				   {    text: 'Nombre del documento',
			        	dataIndex: 'nombreDocumento',
			        	flex: 2
			       },
			       {    text: 'Tipo',
			        	dataIndex: 'tipoDocumento',
			        	flex: 2
			       },
			       {   
			       		text: 'Descripción',
			       	    dataIndex: 'descripcion',
			       		flex: 2,
			       		editor: {
			       			xtype:'textarea'
			       		}
			       },
			       {    text: 'Tamaño',
			        	dataIndex: 'tamanoDocumento',
			        	flex: 2
			       },
				   {
			            text: 'Fecha subida',
			            dataIndex: 'fechaSubida',
			            flex: 2,
			        	formatter: 'date("d/m/Y")'
			            
			       }
			    ];
			    me.selModel = 
			    	{
			          selType: 'checkboxmodel',
			          mode: 'SINGLE'
			      	}; 
			    me.dockedItems = [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true
			        }
			    ];
            
    	me.callParent();
    	
    },
    
    onAddClick: function(btn){
		var me = this;
		var idAgrupacion = me.lookupController().getViewModel().getData().agrupacionficha.id


		Ext.create('HreRem.view.agrupaciones.detalle.AnyadirNuevoDocumentoAgrupacion',{idAgrupacion: idAgrupacion, grid:this}).show();    

    },
    
    onDeleteClick: function(btn){
    	
    }

});