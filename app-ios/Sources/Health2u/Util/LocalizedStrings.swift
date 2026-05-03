// swiftlint:disable file_length type_body_length
import Foundation

public enum LocalizedStrings {
    // MARK: - All localized strings keyed by AppLanguage

    static let strings: [AppLanguage: [String: String]] = [
        .en: en,
        .es: es,
        .ptBR: ptBR,
        .pt: pt,
        .fr: fr,
    ]

    // MARK: - English

    private static let en: [String: String] = [
        // Tabs
        "tab.home": "Home",
        "tab.exams": "Exams",
        "tab.insights": "Insights",
        "tab.records": "Records",
        "tab.ai_upload": "AI Upload",

        // Welcome
        "welcome.brand": "2YH",
        "welcome.sync_active": "Sync Active",
        "welcome.encrypted": "End-to-End Encrypted",

        // Login
        "login.welcome_back": "Welcome Back",
        "login.subtitle": "Sign in to access your health data",
        "login.google": "Continue with Google",
        "login.apple": "Continue with Apple",
        "login.secured_access": "Secured Access",
        "login.no_account": "Don't have an account?",
        "login.join": "Join Now",
        "login.sign_in": "Sign In",
        "login.terms": "Terms of Service",
        "login.privacy": "Privacy Policy",
        "login.coming_soon": "Coming Soon",
        "login.coming_soon_message": "This feature is not yet available.",

        // Dashboard
        "dashboard.health_score": "Health Score",
        "dashboard.last_updated": "Last updated",
        "dashboard.vitals_overview": "Vitals Overview",
        "dashboard.heart_rate": "Heart Rate",
        "dashboard.blood_pressure": "Blood Pressure",
        "dashboard.blood_sugar": "Blood Sugar",
        "dashboard.spo2": "SpO2",
        "dashboard.recent_labs": "Recent Labs",
        "dashboard.upcoming": "Upcoming",
        "dashboard.notifications_title": "Notifications",
        "dashboard.notifications_message": "Stay updated with your health alerts",

        // Exams
        "exams.title": "Exams",
        "exams.clinical_records": "Clinical Records",
        "exams.search": "Search exams...",
        "exams.all": "All",
        "exams.labs": "Labs",
        "exams.radiology": "Radiology",
        "exams.view_report": "View Report",

        // Appointments
        "appointments.title": "Appointments",
        "appointments.upcoming": "Upcoming",
        "appointments.past": "Past",
        "appointments.schedule": "Schedule Appointment",
        "appointments.view_details": "View Details",
        "appointments.confirmed": "Confirmed",
        "appointments.date_time": "Date & Time",
        "appointments.location": "Location",

        // Insights
        "insights.title": "Insights",
        "insights.health_insights": "Health Insights",

        // Profile
        "profile.edit": "Edit Profile",
        "profile.medical_records": "Medical Records",
        "profile.emergency_contacts": "Emergency Contacts",
        "profile.logout": "Logout",

        // Settings
        "settings.title": "Settings",
        "settings.personal_center": "PERSONAL CENTER",
        "settings.app_config": "App Configuration",
        "settings.app_config_desc": "Manage your account security, interface preferences, and clinical data export settings.",
        "settings.account": "ACCOUNT",
        "settings.preferences": "PREFERENCES",
        "settings.language": "Language",
        "settings.notifications": "Notifications",
        "settings.dark_mode": "Dark Mode",
        "settings.units": "Units",
        "settings.metric": "Metric",
        "settings.imperial": "Imperial",
        "settings.data_privacy": "DATA & PRIVACY",
        "settings.export": "Export Data",
        "settings.delete_account": "Delete Account",
        "settings.about": "ABOUT",
        "settings.version": "Version 1.0.0",
        "settings.terms": "Terms of Service",
        "settings.privacy_policy": "Privacy Policy",
        "settings.help": "Help & Support",
        "settings.logout": "Logout",
        "settings.profile": "Profile",
        "settings.change_password": "Change Password",
        "settings.privacy": "Privacy",
        "settings.footer": "SECURE HEALTHCARE GATEWAY",

        // Upload
        "upload.title": "Upload",
        "upload.take_photo": "Take Photo",
        "upload.choose_file": "Choose File",
        "upload.auto_detected": "Auto-detected",

        // Common
        "common.ok": "OK",
        "common.cancel": "Cancel",
        "common.save": "Save",
        "common.delete": "Delete",
        "common.retry": "Retry",
        "common.loading": "Loading...",
        "common.error": "Error",

        // Empty states
        "empty.no_data": "No data available",
        "empty.no_exams": "No exams found",
        "empty.no_appointments": "No appointments scheduled",
    ]

    // MARK: - Spanish

    private static let es: [String: String] = [
        // Tabs
        "tab.home": "Inicio",
        "tab.exams": "Examenes",
        "tab.insights": "Analisis",
        "tab.records": "Registros",
        "tab.ai_upload": "Subir IA",

        // Welcome
        "welcome.brand": "2YH",
        "welcome.sync_active": "Sincronizacion Activa",
        "welcome.encrypted": "Cifrado de Extremo a Extremo",

        // Login
        "login.welcome_back": "Bienvenido de Nuevo",
        "login.subtitle": "Inicia sesion para acceder a tus datos de salud",
        "login.google": "Continuar con Google",
        "login.apple": "Continuar con Apple",
        "login.secured_access": "Acceso Seguro",
        "login.no_account": "No tienes una cuenta?",
        "login.join": "Registrate",
        "login.sign_in": "Iniciar Sesion",
        "login.terms": "Terminos de Servicio",
        "login.privacy": "Politica de Privacidad",
        "login.coming_soon": "Proximamente",
        "login.coming_soon_message": "Esta funcion aun no esta disponible.",

        // Dashboard
        "dashboard.health_score": "Puntuacion de Salud",
        "dashboard.last_updated": "Ultima actualizacion",
        "dashboard.vitals_overview": "Resumen de Signos Vitales",
        "dashboard.heart_rate": "Frecuencia Cardiaca",
        "dashboard.blood_pressure": "Presion Arterial",
        "dashboard.blood_sugar": "Glucosa en Sangre",
        "dashboard.spo2": "SpO2",
        "dashboard.recent_labs": "Laboratorios Recientes",
        "dashboard.upcoming": "Proximos",
        "dashboard.notifications_title": "Notificaciones",
        "dashboard.notifications_message": "Mantente al dia con tus alertas de salud",

        // Exams
        "exams.title": "Examenes",
        "exams.clinical_records": "Registros Clinicos",
        "exams.search": "Buscar examenes...",
        "exams.all": "Todos",
        "exams.labs": "Laboratorio",
        "exams.radiology": "Radiologia",
        "exams.view_report": "Ver Informe",

        // Appointments
        "appointments.title": "Citas",
        "appointments.upcoming": "Proximas",
        "appointments.past": "Anteriores",
        "appointments.schedule": "Agendar Cita",
        "appointments.view_details": "Ver Detalles",
        "appointments.confirmed": "Confirmada",
        "appointments.date_time": "Fecha y Hora",
        "appointments.location": "Ubicacion",

        // Insights
        "insights.title": "Analisis",
        "insights.health_insights": "Informacion de Salud",

        // Profile
        "profile.edit": "Editar Perfil",
        "profile.medical_records": "Historial Medico",
        "profile.emergency_contacts": "Contactos de Emergencia",
        "profile.logout": "Cerrar Sesion",

        // Settings
        "settings.title": "Configuracion",
        "settings.personal_center": "CENTRO PERSONAL",
        "settings.app_config": "Configuracion de la App",
        "settings.app_config_desc": "Administra la seguridad de tu cuenta, preferencias de interfaz y configuracion de exportacion de datos clinicos.",
        "settings.account": "CUENTA",
        "settings.preferences": "PREFERENCIAS",
        "settings.language": "Idioma",
        "settings.notifications": "Notificaciones",
        "settings.dark_mode": "Modo Oscuro",
        "settings.units": "Unidades",
        "settings.metric": "Metrico",
        "settings.imperial": "Imperial",
        "settings.data_privacy": "DATOS Y PRIVACIDAD",
        "settings.export": "Exportar Datos",
        "settings.delete_account": "Eliminar Cuenta",
        "settings.about": "ACERCA DE",
        "settings.version": "Version 1.0.0",
        "settings.terms": "Terminos de Servicio",
        "settings.privacy_policy": "Politica de Privacidad",
        "settings.help": "Ayuda y Soporte",
        "settings.logout": "Cerrar Sesion",
        "settings.profile": "Perfil",
        "settings.change_password": "Cambiar Contrasena",
        "settings.privacy": "Privacidad",
        "settings.footer": "PORTAL SEGURO DE SALUD",

        // Upload
        "upload.title": "Subir",
        "upload.take_photo": "Tomar Foto",
        "upload.choose_file": "Elegir Archivo",
        "upload.auto_detected": "Detectado automaticamente",

        // Common
        "common.ok": "Aceptar",
        "common.cancel": "Cancelar",
        "common.save": "Guardar",
        "common.delete": "Eliminar",
        "common.retry": "Reintentar",
        "common.loading": "Cargando...",
        "common.error": "Error",

        // Empty states
        "empty.no_data": "No hay datos disponibles",
        "empty.no_exams": "No se encontraron examenes",
        "empty.no_appointments": "No hay citas programadas",
    ]

    // MARK: - Portuguese (Brazil)

    private static let ptBR: [String: String] = [
        // Tabs
        "tab.home": "Inicio",
        "tab.exams": "Exames",
        "tab.insights": "Analises",
        "tab.records": "Registros",
        "tab.ai_upload": "Upload IA",

        // Welcome
        "welcome.brand": "2YH",
        "welcome.sync_active": "Sincronizacao Ativa",
        "welcome.encrypted": "Criptografia de Ponta a Ponta",

        // Login
        "login.welcome_back": "Bem-vindo de Volta",
        "login.subtitle": "Entre para acessar seus dados de saude",
        "login.google": "Continuar com Google",
        "login.apple": "Continuar com Apple",
        "login.secured_access": "Acesso Seguro",
        "login.no_account": "Nao tem uma conta?",
        "login.join": "Cadastre-se",
        "login.sign_in": "Entrar",
        "login.terms": "Termos de Servico",
        "login.privacy": "Politica de Privacidade",
        "login.coming_soon": "Em Breve",
        "login.coming_soon_message": "Este recurso ainda nao esta disponivel.",

        // Dashboard
        "dashboard.health_score": "Pontuacao de Saude",
        "dashboard.last_updated": "Ultima atualizacao",
        "dashboard.vitals_overview": "Resumo dos Sinais Vitais",
        "dashboard.heart_rate": "Frequencia Cardiaca",
        "dashboard.blood_pressure": "Pressao Arterial",
        "dashboard.blood_sugar": "Glicemia",
        "dashboard.spo2": "SpO2",
        "dashboard.recent_labs": "Laboratorios Recentes",
        "dashboard.upcoming": "Proximos",
        "dashboard.notifications_title": "Notificacoes",
        "dashboard.notifications_message": "Fique atualizado com seus alertas de saude",

        // Exams
        "exams.title": "Exames",
        "exams.clinical_records": "Registros Clinicos",
        "exams.search": "Buscar exames...",
        "exams.all": "Todos",
        "exams.labs": "Laboratorio",
        "exams.radiology": "Radiologia",
        "exams.view_report": "Ver Relatorio",

        // Appointments
        "appointments.title": "Consultas",
        "appointments.upcoming": "Proximas",
        "appointments.past": "Anteriores",
        "appointments.schedule": "Agendar Consulta",
        "appointments.view_details": "Ver Detalhes",
        "appointments.confirmed": "Confirmada",
        "appointments.date_time": "Data e Hora",
        "appointments.location": "Local",

        // Insights
        "insights.title": "Analises",
        "insights.health_insights": "Insights de Saude",

        // Profile
        "profile.edit": "Editar Perfil",
        "profile.medical_records": "Prontuario Medico",
        "profile.emergency_contacts": "Contatos de Emergencia",
        "profile.logout": "Sair",

        // Settings
        "settings.title": "Configuracoes",
        "settings.personal_center": "CENTRAL PESSOAL",
        "settings.app_config": "Configuracao do App",
        "settings.app_config_desc": "Gerencie a seguranca da sua conta, preferencias de interface e configuracoes de exportacao de dados clinicos.",
        "settings.account": "CONTA",
        "settings.preferences": "PREFERENCIAS",
        "settings.language": "Idioma",
        "settings.notifications": "Notificacoes",
        "settings.dark_mode": "Modo Escuro",
        "settings.units": "Unidades",
        "settings.metric": "Metrico",
        "settings.imperial": "Imperial",
        "settings.data_privacy": "DADOS E PRIVACIDADE",
        "settings.export": "Exportar Dados",
        "settings.delete_account": "Excluir Conta",
        "settings.about": "SOBRE",
        "settings.version": "Versao 1.0.0",
        "settings.terms": "Termos de Servico",
        "settings.privacy_policy": "Politica de Privacidade",
        "settings.help": "Ajuda e Suporte",
        "settings.logout": "Sair",
        "settings.profile": "Perfil",
        "settings.change_password": "Alterar Senha",
        "settings.privacy": "Privacidade",
        "settings.footer": "PORTAL SEGURO DE SAUDE",

        // Upload
        "upload.title": "Upload",
        "upload.take_photo": "Tirar Foto",
        "upload.choose_file": "Escolher Arquivo",
        "upload.auto_detected": "Detectado automaticamente",

        // Common
        "common.ok": "OK",
        "common.cancel": "Cancelar",
        "common.save": "Salvar",
        "common.delete": "Excluir",
        "common.retry": "Tentar Novamente",
        "common.loading": "Carregando...",
        "common.error": "Erro",

        // Empty states
        "empty.no_data": "Nenhum dado disponivel",
        "empty.no_exams": "Nenhum exame encontrado",
        "empty.no_appointments": "Nenhuma consulta agendada",
    ]

    // MARK: - Portuguese (Portugal)

    private static let pt: [String: String] = [
        // Tabs
        "tab.home": "Inicio",
        "tab.exams": "Exames",
        "tab.insights": "Analises",
        "tab.records": "Registos",
        "tab.ai_upload": "Carregar IA",

        // Welcome
        "welcome.brand": "2YH",
        "welcome.sync_active": "Sincronizacao Ativa",
        "welcome.encrypted": "Encriptacao Ponto a Ponto",

        // Login
        "login.welcome_back": "Bem-vindo de Volta",
        "login.subtitle": "Inicie sessao para aceder aos seus dados de saude",
        "login.google": "Continuar com Google",
        "login.apple": "Continuar com Apple",
        "login.secured_access": "Acesso Seguro",
        "login.no_account": "Nao tem uma conta?",
        "login.join": "Registe-se",
        "login.sign_in": "Iniciar Sessao",
        "login.terms": "Termos de Servico",
        "login.privacy": "Politica de Privacidade",
        "login.coming_soon": "Em Breve",
        "login.coming_soon_message": "Esta funcionalidade ainda nao esta disponivel.",

        // Dashboard
        "dashboard.health_score": "Pontuacao de Saude",
        "dashboard.last_updated": "Ultima atualizacao",
        "dashboard.vitals_overview": "Resumo dos Sinais Vitais",
        "dashboard.heart_rate": "Frequencia Cardiaca",
        "dashboard.blood_pressure": "Pressao Arterial",
        "dashboard.blood_sugar": "Glicemia",
        "dashboard.spo2": "SpO2",
        "dashboard.recent_labs": "Laboratorios Recentes",
        "dashboard.upcoming": "Proximos",
        "dashboard.notifications_title": "Notificacoes",
        "dashboard.notifications_message": "Mantenha-se atualizado com os seus alertas de saude",

        // Exams
        "exams.title": "Exames",
        "exams.clinical_records": "Registos Clinicos",
        "exams.search": "Pesquisar exames...",
        "exams.all": "Todos",
        "exams.labs": "Laboratorio",
        "exams.radiology": "Radiologia",
        "exams.view_report": "Ver Relatorio",

        // Appointments
        "appointments.title": "Consultas",
        "appointments.upcoming": "Proximas",
        "appointments.past": "Anteriores",
        "appointments.schedule": "Marcar Consulta",
        "appointments.view_details": "Ver Detalhes",
        "appointments.confirmed": "Confirmada",
        "appointments.date_time": "Data e Hora",
        "appointments.location": "Local",

        // Insights
        "insights.title": "Analises",
        "insights.health_insights": "Informacoes de Saude",

        // Profile
        "profile.edit": "Editar Perfil",
        "profile.medical_records": "Registos Medicos",
        "profile.emergency_contacts": "Contactos de Emergencia",
        "profile.logout": "Terminar Sessao",

        // Settings
        "settings.title": "Definicoes",
        "settings.personal_center": "CENTRO PESSOAL",
        "settings.app_config": "Configuracao da App",
        "settings.app_config_desc": "Faca a gestao da seguranca da sua conta, preferencias de interface e definicoes de exportacao de dados clinicos.",
        "settings.account": "CONTA",
        "settings.preferences": "PREFERENCIAS",
        "settings.language": "Idioma",
        "settings.notifications": "Notificacoes",
        "settings.dark_mode": "Modo Escuro",
        "settings.units": "Unidades",
        "settings.metric": "Metrico",
        "settings.imperial": "Imperial",
        "settings.data_privacy": "DADOS E PRIVACIDADE",
        "settings.export": "Exportar Dados",
        "settings.delete_account": "Eliminar Conta",
        "settings.about": "SOBRE",
        "settings.version": "Versao 1.0.0",
        "settings.terms": "Termos de Servico",
        "settings.privacy_policy": "Politica de Privacidade",
        "settings.help": "Ajuda e Suporte",
        "settings.logout": "Terminar Sessao",
        "settings.profile": "Perfil",
        "settings.change_password": "Alterar Palavra-passe",
        "settings.privacy": "Privacidade",
        "settings.footer": "PORTAL SEGURO DE SAUDE",

        // Upload
        "upload.title": "Carregar",
        "upload.take_photo": "Tirar Fotografia",
        "upload.choose_file": "Escolher Ficheiro",
        "upload.auto_detected": "Detetado automaticamente",

        // Common
        "common.ok": "OK",
        "common.cancel": "Cancelar",
        "common.save": "Guardar",
        "common.delete": "Eliminar",
        "common.retry": "Tentar Novamente",
        "common.loading": "A carregar...",
        "common.error": "Erro",

        // Empty states
        "empty.no_data": "Sem dados disponiveis",
        "empty.no_exams": "Nenhum exame encontrado",
        "empty.no_appointments": "Nenhuma consulta marcada",
    ]

    // MARK: - French

    private static let fr: [String: String] = [
        // Tabs
        "tab.home": "Accueil",
        "tab.exams": "Examens",
        "tab.insights": "Analyses",
        "tab.records": "Dossiers",
        "tab.ai_upload": "Telechargement IA",

        // Welcome
        "welcome.brand": "2YH",
        "welcome.sync_active": "Synchronisation Active",
        "welcome.encrypted": "Chiffrement de bout en bout",

        // Login
        "login.welcome_back": "Bon Retour",
        "login.subtitle": "Connectez-vous pour acceder a vos donnees de sante",
        "login.google": "Continuer avec Google",
        "login.apple": "Continuer avec Apple",
        "login.secured_access": "Acces Securise",
        "login.no_account": "Vous n'avez pas de compte ?",
        "login.join": "Inscrivez-vous",
        "login.sign_in": "Se Connecter",
        "login.terms": "Conditions d'Utilisation",
        "login.privacy": "Politique de Confidentialite",
        "login.coming_soon": "Bientot Disponible",
        "login.coming_soon_message": "Cette fonctionnalite n'est pas encore disponible.",

        // Dashboard
        "dashboard.health_score": "Score de Sante",
        "dashboard.last_updated": "Derniere mise a jour",
        "dashboard.vitals_overview": "Apercu des Signes Vitaux",
        "dashboard.heart_rate": "Frequence Cardiaque",
        "dashboard.blood_pressure": "Pression Arterielle",
        "dashboard.blood_sugar": "Glycemie",
        "dashboard.spo2": "SpO2",
        "dashboard.recent_labs": "Analyses Recentes",
        "dashboard.upcoming": "A Venir",
        "dashboard.notifications_title": "Notifications",
        "dashboard.notifications_message": "Restez informe de vos alertes de sante",

        // Exams
        "exams.title": "Examens",
        "exams.clinical_records": "Dossiers Cliniques",
        "exams.search": "Rechercher des examens...",
        "exams.all": "Tous",
        "exams.labs": "Laboratoire",
        "exams.radiology": "Radiologie",
        "exams.view_report": "Voir le Rapport",

        // Appointments
        "appointments.title": "Rendez-vous",
        "appointments.upcoming": "A Venir",
        "appointments.past": "Passes",
        "appointments.schedule": "Prendre Rendez-vous",
        "appointments.view_details": "Voir les Details",
        "appointments.confirmed": "Confirme",
        "appointments.date_time": "Date et Heure",
        "appointments.location": "Lieu",

        // Insights
        "insights.title": "Analyses",
        "insights.health_insights": "Informations de Sante",

        // Profile
        "profile.edit": "Modifier le Profil",
        "profile.medical_records": "Dossier Medical",
        "profile.emergency_contacts": "Contacts d'Urgence",
        "profile.logout": "Se Deconnecter",

        // Settings
        "settings.title": "Parametres",
        "settings.personal_center": "CENTRE PERSONNEL",
        "settings.app_config": "Configuration de l'App",
        "settings.app_config_desc": "Gerez la securite de votre compte, les preferences d'interface et les parametres d'exportation de donnees cliniques.",
        "settings.account": "COMPTE",
        "settings.preferences": "PREFERENCES",
        "settings.language": "Langue",
        "settings.notifications": "Notifications",
        "settings.dark_mode": "Mode Sombre",
        "settings.units": "Unites",
        "settings.metric": "Metrique",
        "settings.imperial": "Imperial",
        "settings.data_privacy": "DONNEES ET CONFIDENTIALITE",
        "settings.export": "Exporter les Donnees",
        "settings.delete_account": "Supprimer le Compte",
        "settings.about": "A PROPOS",
        "settings.version": "Version 1.0.0",
        "settings.terms": "Conditions d'Utilisation",
        "settings.privacy_policy": "Politique de Confidentialite",
        "settings.help": "Aide et Support",
        "settings.logout": "Se Deconnecter",
        "settings.profile": "Profil",
        "settings.change_password": "Changer le Mot de Passe",
        "settings.privacy": "Confidentialite",
        "settings.footer": "PORTAIL DE SANTE SECURISE",

        // Upload
        "upload.title": "Telecharger",
        "upload.take_photo": "Prendre une Photo",
        "upload.choose_file": "Choisir un Fichier",
        "upload.auto_detected": "Detection automatique",

        // Common
        "common.ok": "OK",
        "common.cancel": "Annuler",
        "common.save": "Enregistrer",
        "common.delete": "Supprimer",
        "common.retry": "Reessayer",
        "common.loading": "Chargement...",
        "common.error": "Erreur",

        // Empty states
        "empty.no_data": "Aucune donnee disponible",
        "empty.no_exams": "Aucun examen trouve",
        "empty.no_appointments": "Aucun rendez-vous programme",
    ]
}
// swiftlint:enable file_length type_body_length
