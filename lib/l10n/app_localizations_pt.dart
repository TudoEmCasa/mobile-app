// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Tudo em Casa';

  @override
  String get products => 'Produtos';

  @override
  String get management => 'Gerenciar';

  @override
  String get managementSubtitle => 'Gerencie a estrutura do app';

  @override
  String get settings => 'Ajustes';

  @override
  String get categories => 'Categorias';

  @override
  String get categoriesManagementSubtitle => 'Organize seus produtos';

  @override
  String get productTypes => 'Tipos de produto';

  @override
  String get productTypesManagementSubtitle => 'Cadastre os tipos disponíveis';

  @override
  String get units => 'Unidades';

  @override
  String get unitsManagementSubtitle => 'Cadastre unidades de medida';

  @override
  String get lots => 'Lotes';

  @override
  String get create => 'Criar';

  @override
  String get update => 'Atualizar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get selectCategory => 'Selecionar categoria';

  @override
  String get selectProductType => 'Selecionar tipo de produto';

  @override
  String get selectUnit => 'Selecionar unidade';

  @override
  String get failedToLoadCategories => 'Falha ao carregar categorias';

  @override
  String get failedToLoadProductTypes => 'Falha ao carregar tipos de produto';

  @override
  String get failedToLoadUnits => 'Falha ao carregar unidades';

  @override
  String get failedToLoadProducts => 'Falha ao carregar produtos';

  @override
  String get failedToLoadProduct => 'Falha ao carregar produto';

  @override
  String get failedToLoadLots => 'Falha ao carregar lotes';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get addProductType => 'Adicionar tipo de produto';

  @override
  String get addUnit => 'Adicionar unidade';

  @override
  String get addProduct => 'Adicionar produto';

  @override
  String get addLot => 'Adicionar lote';

  @override
  String get categoryCreated => 'Categoria criada';

  @override
  String get categoryUpdated => 'Categoria atualizada';

  @override
  String get categoryRemoved => 'Categoria removida';

  @override
  String get productTypeCreated => 'Tipo de produto criado';

  @override
  String get productTypeUpdated => 'Tipo de produto atualizado';

  @override
  String get productTypeRemoved => 'Tipo de produto removido';

  @override
  String get unitCreated => 'Unidade criada';

  @override
  String get unitUpdated => 'Unidade atualizada';

  @override
  String get unitRemoved => 'Unidade removida';

  @override
  String get productCreated => 'Produto criado';

  @override
  String get productUpdated => 'Produto atualizado';

  @override
  String get productRemoved => 'Produto removido';

  @override
  String get lotCreated => 'Lote criado';

  @override
  String get lotUpdated => 'Lote atualizado';

  @override
  String get lotRemoved => 'Lote removido';

  @override
  String get deleteCategoryTitle => 'Excluir categoria?';

  @override
  String get deleteProductTypeTitle => 'Excluir tipo de produto?';

  @override
  String get deleteUnitTitle => 'Excluir unidade?';

  @override
  String get deleteProductTitle => 'Excluir produto?';

  @override
  String get deleteLotTitle => 'Excluir lote?';

  @override
  String deleteNamedEntityMessage(String name) {
    return 'Excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get deleteLotMessage =>
      'Excluir este lote? Esta ação não pode ser desfeita.';

  @override
  String get failedToDeleteCategory => 'Falha ao excluir categoria';

  @override
  String get failedToDeleteProductType => 'Falha ao excluir tipo de produto';

  @override
  String get failedToDeleteUnit => 'Falha ao excluir unidade';

  @override
  String get failedToDeleteProduct => 'Falha ao excluir produto';

  @override
  String get failedToDeleteLot => 'Falha ao excluir lote';

  @override
  String get createCategory => 'Criar categoria';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get categoryName => 'Nome da categoria';

  @override
  String get categoryNameHint => 'ex.: Frutas, Verduras';

  @override
  String get categoryNameRequired => 'O nome da categoria é obrigatório';

  @override
  String get failedToSaveCategory => 'Falha ao salvar categoria';

  @override
  String get noCategoriesYet => 'Nenhuma categoria ainda';

  @override
  String get createCategoryEmptyMessage => 'Crie uma categoria para começar';

  @override
  String get createProductType => 'Criar tipo de produto';

  @override
  String get editProductType => 'Editar tipo de produto';

  @override
  String get productTypeName => 'Nome do tipo de produto';

  @override
  String get productTypeNameHint => 'ex.: Leite, Queijo';

  @override
  String get productTypeNameRequired =>
      'O nome do tipo de produto é obrigatório';

  @override
  String get categoryRequired => 'A categoria é obrigatória';

  @override
  String get failedToSaveProductType => 'Falha ao salvar tipo de produto';

  @override
  String get noProductTypesYet => 'Nenhum tipo de produto ainda';

  @override
  String get createProductTypeEmptyMessage =>
      'Crie um tipo de produto para começar';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String categoryWithName(String name) {
    return 'Categoria: $name';
  }

  @override
  String get selectCategoryLower => 'Selecionar categoria';

  @override
  String get createUnit => 'Criar unidade';

  @override
  String get editUnit => 'Editar unidade';

  @override
  String get unitName => 'Nome da unidade';

  @override
  String get unitLabel => 'Unidade';

  @override
  String get unitNameHint => 'ex.: Quilograma, Litro';

  @override
  String get unitSymbol => 'Abreviação';

  @override
  String get unitSymbolHint => 'ex.: kg, L';

  @override
  String get unitNameRequired => 'O nome da unidade é obrigatório';

  @override
  String get unitSymbolRequired => 'A abreviação da unidade é obrigatória';

  @override
  String get failedToSaveUnit => 'Falha ao salvar unidade';

  @override
  String get noUnitsYet => 'Nenhuma unidade ainda';

  @override
  String get createUnitEmptyMessage => 'Crie uma unidade para começar';

  @override
  String get createProduct => 'Criar produto';

  @override
  String get editProduct => 'Editar produto';

  @override
  String get productName => 'Nome do produto';

  @override
  String get productTypeLabel => 'Tipo de produto';

  @override
  String get selectProductTypeLower => 'Selecionar tipo de produto';

  @override
  String get productNameRequired => 'O nome do produto é obrigatório';

  @override
  String get productTypeRequired => 'O tipo de produto é obrigatório';

  @override
  String get failedToSaveProduct => 'Falha ao salvar produto';

  @override
  String get noProductsYet => 'Nenhum produto ainda';

  @override
  String get createProductEmptyMessage =>
      'Cadastre o primeiro produto para começar.';

  @override
  String get productDetails => 'Detalhes do produto';

  @override
  String get productNotFound => 'Produto não encontrado';

  @override
  String productTypeWithName(String name) {
    return 'Tipo de produto: $name';
  }

  @override
  String lotsCount(int count) {
    return 'Lotes: $count';
  }

  @override
  String get inventoryTrackedPerLot => 'O estoque é controlado por lote.';

  @override
  String get addLotLower => 'Adicionar lote';

  @override
  String get noLotsRegistered => 'Nenhum lote registrado';

  @override
  String get noExpirationDate => 'Sem data de validade';

  @override
  String get editProductTooltip => 'Editar produto';

  @override
  String get deleteProductTooltip => 'Excluir produto';

  @override
  String get createLot => 'Criar lote';

  @override
  String get editLot => 'Editar lote';

  @override
  String get quantity => 'Quantidade';

  @override
  String get quantityMustBeGreaterThanZero =>
      'A quantidade deve ser maior que zero';

  @override
  String get unitRequired => 'A unidade é obrigatória';

  @override
  String get failedToSaveLot => 'Falha ao salvar lote';

  @override
  String get selectUnitLower => 'Selecionar unidade';

  @override
  String get selectExpirationDate => 'Selecionar data de validade';

  @override
  String get noLotsYet => 'Nenhum lote ainda';

  @override
  String get createLotEmptyMessage =>
      'Adicione um lote para controlar quantidade, unidade e data de validade.';

  @override
  String get unitsFallback => 'unidades';

  @override
  String get noExpiration => 'Sem validade';

  @override
  String expiresWithDate(String date) {
    return 'Validade: $date';
  }

  @override
  String get addQuantity => 'Adicionar quantidade';

  @override
  String get useQuantity => 'Usar quantidade';

  @override
  String get editLotTooltip => 'Editar lote';

  @override
  String get deleteLotTooltip => 'Excluir lote';

  @override
  String get enterQuantity => 'Informe uma quantidade';

  @override
  String get enterValidQuantity => 'Informe uma quantidade válida';

  @override
  String get insufficientQuantity => 'Quantidade insuficiente';

  @override
  String get consumeQuantity => 'Consumir quantidade';

  @override
  String get quantityToUse => 'Quantidade a usar';

  @override
  String get quantityToAdd => 'Quantidade a adicionar';

  @override
  String get remaining => 'Restante';

  @override
  String get newTotal => 'Novo total';

  @override
  String get lotFallback => 'Lote';

  @override
  String currentQuantity(String quantity, String unit) {
    return 'Atual: $quantity $unit';
  }

  @override
  String get useAll => 'Usar tudo';

  @override
  String previewQuantity(String label, String quantity, String unit) {
    return '$label: $quantity $unit';
  }

  @override
  String emptyPreviewQuantity(String label) {
    return '$label: --';
  }

  @override
  String quantityUsed(String quantity) {
    return 'Quantidade usada: $quantity';
  }

  @override
  String quantityAdded(String quantity) {
    return 'Quantidade adicionada: $quantity';
  }

  @override
  String get appearance => 'Aparência';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get portugueseLanguage => 'Português';

  @override
  String get englishLanguage => 'Inglês';

  @override
  String get dataManagement => 'Dados';

  @override
  String get importData => 'Importar dados';

  @override
  String get importDataSubtitle => 'Restaurar a partir de um backup JSON local';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get exportDataSubtitle => 'Criar um backup JSON local';

  @override
  String get importCanceled => 'Importação cancelada';

  @override
  String get exportCanceled => 'Exportação cancelada';

  @override
  String get importConfirmationMessage =>
      'Importar um backup substituirá os dados locais atuais.';

  @override
  String get backupImportedSuccessfully => 'Backup importado com sucesso';

  @override
  String get failedToRestoreLocalDatabase =>
      'Falha ao restaurar banco de dados local';

  @override
  String get backupExportedSuccessfully => 'Backup exportado com sucesso';

  @override
  String get failedToExportBackup => 'Falha ao exportar backup';

  @override
  String get about => 'Sobre';

  @override
  String get versionLabel => 'Versão 1.0.0';

  @override
  String get licenses => 'Licenças';

  @override
  String get licensesSubtitle => 'Ver licenças de código aberto';

  @override
  String get exportDataBackupDialogTitle => 'Exportar backup de dados';

  @override
  String get importDataBackupDialogTitle => 'Importar backup de dados';

  @override
  String get failedToExportData => 'Falha ao exportar dados.';

  @override
  String get backupDataCorrupted => 'Os dados do backup estão corrompidos.';

  @override
  String get invalidBackupFile => 'Arquivo de backup inválido.';

  @override
  String get unsupportedBackupVersion => 'Versão de backup não compatível.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Tudo em Casa';

  @override
  String get products => 'Produtos';

  @override
  String get management => 'Gerenciar';

  @override
  String get managementSubtitle => 'Gerencie a estrutura do app';

  @override
  String get settings => 'Ajustes';

  @override
  String get categories => 'Categorias';

  @override
  String get categoriesManagementSubtitle => 'Organize seus produtos';

  @override
  String get productTypes => 'Tipos de produto';

  @override
  String get productTypesManagementSubtitle => 'Cadastre os tipos disponíveis';

  @override
  String get units => 'Unidades';

  @override
  String get unitsManagementSubtitle => 'Cadastre unidades de medida';

  @override
  String get lots => 'Lotes';

  @override
  String get create => 'Criar';

  @override
  String get update => 'Atualizar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get selectCategory => 'Selecionar categoria';

  @override
  String get selectProductType => 'Selecionar tipo de produto';

  @override
  String get selectUnit => 'Selecionar unidade';

  @override
  String get failedToLoadCategories => 'Falha ao carregar categorias';

  @override
  String get failedToLoadProductTypes => 'Falha ao carregar tipos de produto';

  @override
  String get failedToLoadUnits => 'Falha ao carregar unidades';

  @override
  String get failedToLoadProducts => 'Falha ao carregar produtos';

  @override
  String get failedToLoadProduct => 'Falha ao carregar produto';

  @override
  String get failedToLoadLots => 'Falha ao carregar lotes';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get addProductType => 'Adicionar tipo de produto';

  @override
  String get addUnit => 'Adicionar unidade';

  @override
  String get addProduct => 'Adicionar produto';

  @override
  String get addLot => 'Adicionar lote';

  @override
  String get categoryCreated => 'Categoria criada';

  @override
  String get categoryUpdated => 'Categoria atualizada';

  @override
  String get categoryRemoved => 'Categoria removida';

  @override
  String get productTypeCreated => 'Tipo de produto criado';

  @override
  String get productTypeUpdated => 'Tipo de produto atualizado';

  @override
  String get productTypeRemoved => 'Tipo de produto removido';

  @override
  String get unitCreated => 'Unidade criada';

  @override
  String get unitUpdated => 'Unidade atualizada';

  @override
  String get unitRemoved => 'Unidade removida';

  @override
  String get productCreated => 'Produto criado';

  @override
  String get productUpdated => 'Produto atualizado';

  @override
  String get productRemoved => 'Produto removido';

  @override
  String get lotCreated => 'Lote criado';

  @override
  String get lotUpdated => 'Lote atualizado';

  @override
  String get lotRemoved => 'Lote removido';

  @override
  String get deleteCategoryTitle => 'Excluir categoria?';

  @override
  String get deleteProductTypeTitle => 'Excluir tipo de produto?';

  @override
  String get deleteUnitTitle => 'Excluir unidade?';

  @override
  String get deleteProductTitle => 'Excluir produto?';

  @override
  String get deleteLotTitle => 'Excluir lote?';

  @override
  String deleteNamedEntityMessage(String name) {
    return 'Excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get deleteLotMessage =>
      'Excluir este lote? Esta ação não pode ser desfeita.';

  @override
  String get failedToDeleteCategory => 'Falha ao excluir categoria';

  @override
  String get failedToDeleteProductType => 'Falha ao excluir tipo de produto';

  @override
  String get failedToDeleteUnit => 'Falha ao excluir unidade';

  @override
  String get failedToDeleteProduct => 'Falha ao excluir produto';

  @override
  String get failedToDeleteLot => 'Falha ao excluir lote';

  @override
  String get createCategory => 'Criar categoria';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get categoryName => 'Nome da categoria';

  @override
  String get categoryNameHint => 'ex.: Frutas, Verduras';

  @override
  String get categoryNameRequired => 'O nome da categoria é obrigatório';

  @override
  String get failedToSaveCategory => 'Falha ao salvar categoria';

  @override
  String get noCategoriesYet => 'Nenhuma categoria ainda';

  @override
  String get createCategoryEmptyMessage => 'Crie uma categoria para começar';

  @override
  String get createProductType => 'Criar tipo de produto';

  @override
  String get editProductType => 'Editar tipo de produto';

  @override
  String get productTypeName => 'Nome do tipo de produto';

  @override
  String get productTypeNameHint => 'ex.: Leite, Queijo';

  @override
  String get productTypeNameRequired =>
      'O nome do tipo de produto é obrigatório';

  @override
  String get categoryRequired => 'A categoria é obrigatória';

  @override
  String get failedToSaveProductType => 'Falha ao salvar tipo de produto';

  @override
  String get noProductTypesYet => 'Nenhum tipo de produto ainda';

  @override
  String get createProductTypeEmptyMessage =>
      'Crie um tipo de produto para começar';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String categoryWithName(String name) {
    return 'Categoria: $name';
  }

  @override
  String get selectCategoryLower => 'Selecionar categoria';

  @override
  String get createUnit => 'Criar unidade';

  @override
  String get editUnit => 'Editar unidade';

  @override
  String get unitName => 'Nome da unidade';

  @override
  String get unitLabel => 'Unidade';

  @override
  String get unitNameHint => 'ex.: Quilograma, Litro';

  @override
  String get unitSymbol => 'Abreviação';

  @override
  String get unitSymbolHint => 'ex.: kg, L';

  @override
  String get unitNameRequired => 'O nome da unidade é obrigatório';

  @override
  String get unitSymbolRequired => 'A abreviação da unidade é obrigatória';

  @override
  String get failedToSaveUnit => 'Falha ao salvar unidade';

  @override
  String get noUnitsYet => 'Nenhuma unidade ainda';

  @override
  String get createUnitEmptyMessage => 'Crie uma unidade para começar';

  @override
  String get createProduct => 'Criar produto';

  @override
  String get editProduct => 'Editar produto';

  @override
  String get productName => 'Nome do produto';

  @override
  String get productTypeLabel => 'Tipo de produto';

  @override
  String get selectProductTypeLower => 'Selecionar tipo de produto';

  @override
  String get productNameRequired => 'O nome do produto é obrigatório';

  @override
  String get productTypeRequired => 'O tipo de produto é obrigatório';

  @override
  String get failedToSaveProduct => 'Falha ao salvar produto';

  @override
  String get noProductsYet => 'Nenhum produto ainda';

  @override
  String get createProductEmptyMessage =>
      'Cadastre o primeiro produto para começar.';

  @override
  String get productDetails => 'Detalhes do produto';

  @override
  String get productNotFound => 'Produto não encontrado';

  @override
  String productTypeWithName(String name) {
    return 'Tipo de produto: $name';
  }

  @override
  String lotsCount(int count) {
    return 'Lotes: $count';
  }

  @override
  String get inventoryTrackedPerLot => 'O estoque é controlado por lote.';

  @override
  String get addLotLower => 'Adicionar lote';

  @override
  String get noLotsRegistered => 'Nenhum lote registrado';

  @override
  String get noExpirationDate => 'Sem data de validade';

  @override
  String get editProductTooltip => 'Editar produto';

  @override
  String get deleteProductTooltip => 'Excluir produto';

  @override
  String get createLot => 'Criar lote';

  @override
  String get editLot => 'Editar lote';

  @override
  String get quantity => 'Quantidade';

  @override
  String get quantityMustBeGreaterThanZero =>
      'A quantidade deve ser maior que zero';

  @override
  String get unitRequired => 'A unidade é obrigatória';

  @override
  String get failedToSaveLot => 'Falha ao salvar lote';

  @override
  String get selectUnitLower => 'Selecionar unidade';

  @override
  String get selectExpirationDate => 'Selecionar data de validade';

  @override
  String get noLotsYet => 'Nenhum lote ainda';

  @override
  String get createLotEmptyMessage =>
      'Adicione um lote para controlar quantidade, unidade e data de validade.';

  @override
  String get unitsFallback => 'unidades';

  @override
  String get noExpiration => 'Sem validade';

  @override
  String expiresWithDate(String date) {
    return 'Validade: $date';
  }

  @override
  String get addQuantity => 'Adicionar quantidade';

  @override
  String get useQuantity => 'Usar quantidade';

  @override
  String get editLotTooltip => 'Editar lote';

  @override
  String get deleteLotTooltip => 'Excluir lote';

  @override
  String get enterQuantity => 'Informe uma quantidade';

  @override
  String get enterValidQuantity => 'Informe uma quantidade válida';

  @override
  String get insufficientQuantity => 'Quantidade insuficiente';

  @override
  String get consumeQuantity => 'Consumir quantidade';

  @override
  String get quantityToUse => 'Quantidade a usar';

  @override
  String get quantityToAdd => 'Quantidade a adicionar';

  @override
  String get remaining => 'Restante';

  @override
  String get newTotal => 'Novo total';

  @override
  String get lotFallback => 'Lote';

  @override
  String currentQuantity(String quantity, String unit) {
    return 'Atual: $quantity $unit';
  }

  @override
  String get useAll => 'Usar tudo';

  @override
  String previewQuantity(String label, String quantity, String unit) {
    return '$label: $quantity $unit';
  }

  @override
  String emptyPreviewQuantity(String label) {
    return '$label: --';
  }

  @override
  String quantityUsed(String quantity) {
    return 'Quantidade usada: $quantity';
  }

  @override
  String quantityAdded(String quantity) {
    return 'Quantidade adicionada: $quantity';
  }

  @override
  String get appearance => 'Aparência';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get portugueseLanguage => 'Português';

  @override
  String get englishLanguage => 'Inglês';

  @override
  String get dataManagement => 'Dados';

  @override
  String get importData => 'Importar dados';

  @override
  String get importDataSubtitle => 'Restaurar a partir de um backup JSON local';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get exportDataSubtitle => 'Criar um backup JSON local';

  @override
  String get importCanceled => 'Importação cancelada';

  @override
  String get exportCanceled => 'Exportação cancelada';

  @override
  String get importConfirmationMessage =>
      'Importar um backup substituirá os dados locais atuais.';

  @override
  String get backupImportedSuccessfully => 'Backup importado com sucesso';

  @override
  String get failedToRestoreLocalDatabase =>
      'Falha ao restaurar banco de dados local';

  @override
  String get backupExportedSuccessfully => 'Backup exportado com sucesso';

  @override
  String get failedToExportBackup => 'Falha ao exportar backup';

  @override
  String get about => 'Sobre';

  @override
  String get versionLabel => 'Versão 1.0.0';

  @override
  String get licenses => 'Licenças';

  @override
  String get licensesSubtitle => 'Ver licenças de código aberto';

  @override
  String get exportDataBackupDialogTitle => 'Exportar backup de dados';

  @override
  String get importDataBackupDialogTitle => 'Importar backup de dados';

  @override
  String get failedToExportData => 'Falha ao exportar dados.';

  @override
  String get backupDataCorrupted => 'Os dados do backup estão corrompidos.';

  @override
  String get invalidBackupFile => 'Arquivo de backup inválido.';

  @override
  String get unsupportedBackupVersion => 'Versão de backup não compatível.';
}
