Ext.define('HreRem.model.PerfilDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.perfildetalle',

    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.Perfil', 'HreRem.model.FichaPerfilModel'],
    
    data: {
    	perfil: null
    },
    
    stores: {
		getPerfil: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.FichaPerfilModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'perfil/getPerfilById',
				extraParams: {id: '{perfil.pefId}'}
			},
			autoLoad: true
		},
		getFunciones: {
			pageSize: $AC.getDefaultPageSize(),
			model: 'HreRem.model.FichaPerfilModel',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'perfil/getFuncionesByPerfilId',
				extraParams: {id: '{perfil.pefId}'}
			},
			autoLoad: true
		}
    } 
});