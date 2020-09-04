Ext.define('HreRem.model.VImporteGastoLbkGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    
    fields: [
    		{
    			name:'idElemento'
    		},
    		{
    			name:'tipoElemento'
    		},
    		{
    			name:'importeGasto'
    		}
    ],
	proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'gastosproveedor/getVImporteGastoLbk',
		api: {
            read: 'gastosproveedor/getVImporteGastoLbk'
        }
    }
});