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

        // Dashboard extras
        "dashboard.cardiovascular_message": "Your cardiovascular health improved by 4% since your last visit.",
        "dashboard.see_all": "See All",

        // Login extras
        "login.email": "Email",
        "login.password": "Password",

        // Exams extras
        "exams.all_records": "All Records",
        "exams.lab_results": "Lab Results",
        "exams.cardiology": "Cardiology",
        "exams.general": "General",
        "exams.imaging": "Imaging",
        "exams.live": "Live",

        // Exam Detail
        "exam_detail.loading": "Loading exam...",
        "exam_detail.title": "Exam Details",
        "exam_detail.file_preview": "File Preview",
        "exam_detail.no_file": "No file attached",
        "exam_detail.details_section": "Details",
        "exam_detail.type_label": "Type",
        "exam_detail.date_label": "Date",
        "exam_detail.created_label": "Created",
        "exam_detail.updated_label": "Updated",
        "exam_detail.notes_section": "Notes",
        "exam_detail.delete_button": "Delete Exam",

        // Appointments extras
        "appointments.loading": "Loading appointments...",
        "appointments.error_title": "Unable to load appointments",
        "appointments.no_appointments_title": "No appointments",
        "appointments.no_upcoming_message": "You have no upcoming appointments.",
        "appointments.no_upcoming": "No upcoming appointments",
        "appointments.no_past": "No past appointments",
        "appointments.completed": "Completed",
        "appointments.cancelled": "Cancelled",
        "appointments.schedule_new": "Schedule New",

        // Appointment Detail
        "appointment_detail.loading": "Loading appointment...",
        "appointment_detail.title": "Appointment Details",
        "appointment_detail.doctor_label": "Doctor",
        "appointment_detail.date_time_label": "Date & Time",
        "appointment_detail.location_label": "Location",
        "appointment_detail.reminder_label": "Reminder",
        "appointment_detail.minutes_before": "minutes before",
        "appointment_detail.description_label": "Description",
        "appointment_detail.cancel_button": "Cancel Appointment",

        // Profile extras
        "profile.date_of_birth": "Date of Birth",
        "profile.not_set": "Not set",
        "profile.gender": "Gender",
        "profile.height": "Height",
        "profile.weight": "Weight",
        "profile.blood_type": "Blood Type",
        "profile.allergies": "Allergies",
        "profile.medications": "Medications",
        "profile.past_conditions": "Past Conditions",
        "profile.chronic_conditions": "Chronic Conditions",
        "profile.active_asthma": "Active Asthma",
        "profile.view_all": "View All",
        "profile.emergency_contact_placeholder": "Emergency Contact",
        "profile.tap_to_manage": "Tap to manage",

        // Edit Profile
        "edit_profile.title": "Edit Profile",
        "edit_profile.save_button": "Save Changes",
        "edit_profile.change_photo": "Change Photo",
        "edit_profile.full_name": "Full Name",
        "edit_profile.email": "Email",
        "edit_profile.phone": "Phone",
        "edit_profile.date_of_birth": "Date of Birth",
        "edit_profile.gender": "Gender",
        "edit_profile.gender_male": "Male",
        "edit_profile.gender_female": "Female",
        "edit_profile.gender_other": "Other",
        "edit_profile.gender_prefer_not": "Prefer not to say",
        "edit_profile.height_cm": "Height (cm)",
        "edit_profile.weight_kg": "Weight (kg)",
        "edit_profile.blood_type": "Blood Type",
        "common.select": "Select",

        // Upload extras
        "upload.upload_button": "Upload Exam",
        "upload.photo_captured": "Photo captured",
        "upload.add_exam_title": "Add your exam",
        "upload.file_types_message": "PDF, JPG, PNG up to 10MB",
        "upload.type_label": "Type",
        "upload.title_label": "Title (Optional)",
        "upload.title_placeholder": "Optional — AI will name this",
        "upload.exam_date_label": "Exam Date",
        "upload.notes_label": "Notes",
        "common.remove": "Remove",

        // Emergency Contacts
        "emergency_contacts.loading": "Loading contacts...",
        "emergency_contacts.error_title": "Unable to load contacts",
        "emergency_contacts.no_contacts_title": "No Emergency Contacts",
        "emergency_contacts.no_contacts_message": "Add your emergency contacts so they can be reached quickly when needed.",
        "emergency_contacts.add_contact": "Add Contact",
        "emergency_contacts.primary_badge": "Primary",
        "emergency_contacts.name_field": "Name",
        "emergency_contacts.relationship_field": "Relationship",
        "emergency_contacts.phone_field": "Phone",
        "emergency_contacts.email_field": "Email",

        // Registration
        "registration.success_title": "Account Created",
        "registration.success_message": "Account created! Please sign in.",
        "registration.create_account": "Create Account",
        "registration.subtitle": "Join to manage your health records",
        "registration.full_name": "Full Name",
        "registration.email": "Email",
        "registration.password": "Password",
        "registration.confirm_password": "Confirm Password",
        "registration.agree_terms": "I agree to the Terms of Service",
        "registration.already_have_account": "Already have an account?",

        // Notifications
        "notifications.title": "Notifications",
        "notifications.loading": "Loading notifications...",
        "notifications.no_notifications_title": "No notifications yet",
        "notifications.no_notifications_message": "We'll let you know when something needs your attention.",
        "notifications.time_just_now": "Just now",
        "notifications.time_yesterday": "Yesterday",

        // Insights extras
        "insights.no_insights_title": "No insights yet",
        "insights.no_insights_message": "Insights will appear as you add more health data.",
        "insights.metabolic_stability": "Metabolic Stability",
        "insights.longevity_score_title": "Predictive Longevity Score",
        "insights.longevity_score_message": "Based on your current health metrics",
        "insights.metric_sleep": "Sleep",
        "insights.metric_stress": "Stress",
        "insights.metric_activity": "Activity",
        "insights.metric_nutrition": "Nutrition",
        "insights.recent_reports": "Recent Reports",

        // Exam Categories
        "exam_category.lab": "Laboratory",
        "exam_category.imaging": "Imaging",
        "exam_category.cardio_functional": "Cardio & Functional",
        "exam_category.preventive_screening": "Preventive & Screening",
        "exam_category.lab_description": "Blood tests, biochemistry, urine, stool",
        "exam_category.imaging_description": "X-ray, ultrasound, MRI, CT, mammography",
        "exam_category.cardio_functional_description": "ECG, stress test, Holter, spirometry",
        "exam_category.preventive_screening_description": "Pap smear, colonoscopy, prostate, bone density",

        // Home extras
        "home.my_health": "My Health",
        "home.my_exams": "My Exams",
        "home.my_vaccines": "My Vaccines",
        "home.medications": "Medications",
        "home.appointments": "Appointments",
        "home.others": "Others",
        "home.coming_soon": "Coming Soon",

        // My Health
        "my_health.title": "My Health",
        "my_health.scoring_coming_soon": "Scoring methodology coming soon",
        "my_health.no_exams": "No exams uploaded yet",
        "my_health.year_exams": "exams",

        // Profile diabetes/allergies
        "profile.diabetes": "Diabetes",
        "profile.has_allergies": "Allergies",
        "profile.yes": "Yes",
        "profile.no": "No",

        // Allergies
        "allergies.title": "My Allergies",
        "allergies.add": "Add Allergy",
        "allergies.name": "Allergy Name",
        "allergies.severity": "Severity",
        "allergies.notes": "Notes",
        "allergies.severity_low": "Low",
        "allergies.severity_medium": "Medium",
        "allergies.severity_high": "High",
        "allergies.no_allergies": "No allergies added",
        "allergies.no_allergies_message": "Add your allergies to keep them on record.",
        "allergies.name_placeholder": "e.g., Peanuts, Penicillin",

        // Common yes/no
        "common.yes": "Yes",
        "common.no": "No",

        // Dashboard cards
        "dashboard.greeting": "Hello",
        "dashboard.my_health": "My Health",
        "dashboard.my_exams": "My Exams",
        "dashboard.my_vaccines": "My Vaccines",
        "dashboard.medications": "Medications",
        "dashboard.appointments": "Appointments",
        "dashboard.others": "Others",
        "dashboard.coming_soon": "Coming Soon",

        // Edit Profile extras
        "edit_profile.diabetes": "Diabetes",
        "edit_profile.allergies": "Allergies",
        "edit_profile.manage_allergies": "Manage Allergies",

        // Upload extras
        "upload.category_label": "Category",

        // AI Analysis — Upload
        "upload.not_an_exam": "This file doesn't appear to be a medical document and was skipped",
        "upload.not_an_exam_reason": "Reason: %@",

        // AI Analysis — Exam
        "exam.ai_summary": "AI Summary",
        "exam.ai_analyzed_badge": "AI Analyzed",
        "exam.processing": "Analyzing...",
        "exam.analysis_failed": "Analysis failed",
        "exam.reanalyze": "Re-analyze",
        "exam.lab_results": "Lab Results",
        "exam.prescription": "Prescription",
        "exam.imaging_report": "Imaging Report",
        "exam.test_name": "Test",
        "exam.value": "Value",
        "exam.unit": "Unit",
        "exam.reference_range": "Reference Range",
        "exam.flag_normal": "Normal",
        "exam.flag_high": "High",
        "exam.flag_low": "Low",
        "exam.medication": "Medication",
        "exam.dosage": "Dosage",
        "exam.frequency": "Frequency",
        "exam.duration": "Duration",
        "exam.modality": "Modality",
        "exam.body_part": "Body Part",
        "exam.findings": "Findings",
        "exam.impression": "Impression",

        // AI Analysis — MyHealth / Dashboard
        "myhealth.ai_analyzed": "%d AI-analyzed",
        "dashboard.from_exam": "From your latest exam",
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

        // Dashboard extras
        "dashboard.cardiovascular_message": "Tu salud cardiovascular mejoro un 4% desde tu ultima visita.",
        "dashboard.see_all": "Ver Todo",

        // Login extras
        "login.email": "Correo Electronico",
        "login.password": "Contrasena",

        // Exams extras
        "exams.all_records": "Todos los Registros",
        "exams.lab_results": "Resultados de Laboratorio",
        "exams.cardiology": "Cardiologia",
        "exams.general": "General",
        "exams.imaging": "Imagenologia",
        "exams.live": "En Vivo",

        // Exam Detail
        "exam_detail.loading": "Cargando examen...",
        "exam_detail.title": "Detalles del Examen",
        "exam_detail.file_preview": "Vista Previa del Archivo",
        "exam_detail.no_file": "Sin archivo adjunto",
        "exam_detail.details_section": "Detalles",
        "exam_detail.type_label": "Tipo",
        "exam_detail.date_label": "Fecha",
        "exam_detail.created_label": "Creado",
        "exam_detail.updated_label": "Actualizado",
        "exam_detail.notes_section": "Notas",
        "exam_detail.delete_button": "Eliminar Examen",

        // Appointments extras
        "appointments.loading": "Cargando citas...",
        "appointments.error_title": "No se pudieron cargar las citas",
        "appointments.no_appointments_title": "Sin citas",
        "appointments.no_upcoming_message": "No tienes citas proximas.",
        "appointments.no_upcoming": "Sin citas proximas",
        "appointments.no_past": "Sin citas anteriores",
        "appointments.completed": "Completada",
        "appointments.cancelled": "Cancelada",
        "appointments.schedule_new": "Agendar Nueva",

        // Appointment Detail
        "appointment_detail.loading": "Cargando cita...",
        "appointment_detail.title": "Detalles de la Cita",
        "appointment_detail.doctor_label": "Medico",
        "appointment_detail.date_time_label": "Fecha y Hora",
        "appointment_detail.location_label": "Ubicacion",
        "appointment_detail.reminder_label": "Recordatorio",
        "appointment_detail.minutes_before": "minutos antes",
        "appointment_detail.description_label": "Descripcion",
        "appointment_detail.cancel_button": "Cancelar Cita",

        // Profile extras
        "profile.date_of_birth": "Fecha de Nacimiento",
        "profile.not_set": "No definido",
        "profile.gender": "Genero",
        "profile.height": "Estatura",
        "profile.weight": "Peso",
        "profile.blood_type": "Tipo de Sangre",
        "profile.allergies": "Alergias",
        "profile.medications": "Medicamentos",
        "profile.past_conditions": "Condiciones Previas",
        "profile.chronic_conditions": "Condiciones Cronicas",
        "profile.active_asthma": "Asma Activa",
        "profile.view_all": "Ver Todo",
        "profile.emergency_contact_placeholder": "Contacto de Emergencia",
        "profile.tap_to_manage": "Toca para gestionar",

        // Edit Profile
        "edit_profile.title": "Editar Perfil",
        "edit_profile.save_button": "Guardar Cambios",
        "edit_profile.change_photo": "Cambiar Foto",
        "edit_profile.full_name": "Nombre Completo",
        "edit_profile.email": "Correo Electronico",
        "edit_profile.phone": "Telefono",
        "edit_profile.date_of_birth": "Fecha de Nacimiento",
        "edit_profile.gender": "Genero",
        "edit_profile.gender_male": "Masculino",
        "edit_profile.gender_female": "Femenino",
        "edit_profile.gender_other": "Otro",
        "edit_profile.gender_prefer_not": "Prefiero no decir",
        "edit_profile.height_cm": "Estatura (cm)",
        "edit_profile.weight_kg": "Peso (kg)",
        "edit_profile.blood_type": "Tipo de Sangre",
        "common.select": "Seleccionar",

        // Upload extras
        "upload.upload_button": "Subir Examen",
        "upload.photo_captured": "Foto capturada",
        "upload.add_exam_title": "Agrega tu examen",
        "upload.file_types_message": "PDF, JPG, PNG hasta 10MB",
        "upload.type_label": "Tipo",
        "upload.title_label": "Titulo (Opcional)",
        "upload.title_placeholder": "Opcional — la IA lo nombrara",
        "upload.exam_date_label": "Fecha del Examen",
        "upload.notes_label": "Notas",
        "common.remove": "Eliminar",

        // Emergency Contacts
        "emergency_contacts.loading": "Cargando contactos...",
        "emergency_contacts.error_title": "No se pudieron cargar los contactos",
        "emergency_contacts.no_contacts_title": "Sin Contactos de Emergencia",
        "emergency_contacts.no_contacts_message": "Agrega tus contactos de emergencia para que puedan ser contactados rapidamente cuando sea necesario.",
        "emergency_contacts.add_contact": "Agregar Contacto",
        "emergency_contacts.primary_badge": "Principal",
        "emergency_contacts.name_field": "Nombre",
        "emergency_contacts.relationship_field": "Parentesco",
        "emergency_contacts.phone_field": "Telefono",
        "emergency_contacts.email_field": "Correo Electronico",

        // Registration
        "registration.success_title": "Cuenta Creada",
        "registration.success_message": "Cuenta creada! Inicia sesion.",
        "registration.create_account": "Crear Cuenta",
        "registration.subtitle": "Registrate para gestionar tus registros de salud",
        "registration.full_name": "Nombre Completo",
        "registration.email": "Correo Electronico",
        "registration.password": "Contrasena",
        "registration.confirm_password": "Confirmar Contrasena",
        "registration.agree_terms": "Acepto los Terminos de Servicio",
        "registration.already_have_account": "Ya tienes una cuenta?",

        // Notifications
        "notifications.title": "Notificaciones",
        "notifications.loading": "Cargando notificaciones...",
        "notifications.no_notifications_title": "Sin notificaciones",
        "notifications.no_notifications_message": "Te avisaremos cuando algo necesite tu atencion.",
        "notifications.time_just_now": "Ahora mismo",
        "notifications.time_yesterday": "Ayer",

        // Insights extras
        "insights.no_insights_title": "Sin analisis aun",
        "insights.no_insights_message": "Los analisis apareceran a medida que agregues mas datos de salud.",
        "insights.metabolic_stability": "Estabilidad Metabolica",
        "insights.longevity_score_title": "Puntuacion Predictiva de Longevidad",
        "insights.longevity_score_message": "Basado en tus metricas de salud actuales",
        "insights.metric_sleep": "Sueno",
        "insights.metric_stress": "Estres",
        "insights.metric_activity": "Actividad",
        "insights.metric_nutrition": "Nutricion",
        "insights.recent_reports": "Informes Recientes",

        // Exam Categories
        "exam_category.lab": "Laboratorio",
        "exam_category.imaging": "Imagen",
        "exam_category.cardio_functional": "Cardio y Funcional",
        "exam_category.preventive_screening": "Preventivos y Rastreo",
        "exam_category.lab_description": "Analisis de sangre, bioquimica, orina, heces",
        "exam_category.imaging_description": "Rayos X, ecografia, resonancia magnetica, tomografia, mamografia",
        "exam_category.cardio_functional_description": "ECG, prueba de esfuerzo, Holter, espirometria",
        "exam_category.preventive_screening_description": "Papanicolau, colonoscopia, prostata, densitometria osea",

        // Home extras
        "home.my_health": "Mi Salud",
        "home.my_exams": "Mis Examenes",
        "home.my_vaccines": "Mis Vacunas",
        "home.medications": "Medicamentos",
        "home.appointments": "Consultas",
        "home.others": "Otros",
        "home.coming_soon": "Proximamente",

        // My Health
        "my_health.title": "Mi Salud",
        "my_health.scoring_coming_soon": "Metodologia de puntuacion proximamente",
        "my_health.no_exams": "Aun no se han subido examenes",
        "my_health.year_exams": "examenes",

        // Profile diabetes/allergies
        "profile.diabetes": "Diabetes",
        "profile.has_allergies": "Alergias",
        "profile.yes": "Si",
        "profile.no": "No",

        // Allergies
        "allergies.title": "Mis Alergias",
        "allergies.add": "Agregar Alergia",
        "allergies.name": "Nombre de la Alergia",
        "allergies.severity": "Severidad",
        "allergies.notes": "Notas",
        "allergies.severity_low": "Baja",
        "allergies.severity_medium": "Media",
        "allergies.severity_high": "Alta",
        "allergies.no_allergies": "Sin alergias registradas",
        "allergies.no_allergies_message": "Agrega tus alergias para mantenerlas en tu historial.",
        "allergies.name_placeholder": "ej., Mani, Penicilina",

        // Common yes/no
        "common.yes": "Si",
        "common.no": "No",

        // Dashboard cards
        "dashboard.greeting": "Hola",
        "dashboard.my_health": "Mi Salud",
        "dashboard.my_exams": "Mis Examenes",
        "dashboard.my_vaccines": "Mis Vacunas",
        "dashboard.medications": "Medicamentos",
        "dashboard.appointments": "Consultas",
        "dashboard.others": "Otros",
        "dashboard.coming_soon": "Proximamente",

        // Edit Profile extras
        "edit_profile.diabetes": "Diabetes",
        "edit_profile.allergies": "Alergias",
        "edit_profile.manage_allergies": "Gestionar Alergias",

        // Upload extras
        "upload.category_label": "Categoria",

        // AI Analysis — Upload
        "upload.not_an_exam": "Este archivo no parece ser un documento medico y fue omitido",
        "upload.not_an_exam_reason": "Motivo: %@",

        // AI Analysis — Exam
        "exam.ai_summary": "Resumen de IA",
        "exam.ai_analyzed_badge": "Analizado por IA",
        "exam.processing": "Analizando...",
        "exam.analysis_failed": "Analisis fallido",
        "exam.reanalyze": "Reanalizar",
        "exam.lab_results": "Resultados de Laboratorio",
        "exam.prescription": "Receta",
        "exam.imaging_report": "Informe de Imagen",
        "exam.test_name": "Prueba",
        "exam.value": "Valor",
        "exam.unit": "Unidad",
        "exam.reference_range": "Rango de Referencia",
        "exam.flag_normal": "Normal",
        "exam.flag_high": "Alto",
        "exam.flag_low": "Bajo",
        "exam.medication": "Medicamento",
        "exam.dosage": "Dosis",
        "exam.frequency": "Frecuencia",
        "exam.duration": "Duracion",
        "exam.modality": "Modalidad",
        "exam.body_part": "Parte del Cuerpo",
        "exam.findings": "Hallazgos",
        "exam.impression": "Impresion",

        // AI Analysis — MyHealth / Dashboard
        "myhealth.ai_analyzed": "%d analizados por IA",
        "dashboard.from_exam": "De tu ultimo examen",
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

        // Dashboard extras
        "dashboard.cardiovascular_message": "Sua saude cardiovascular melhorou 4% desde sua ultima visita.",
        "dashboard.see_all": "Ver Tudo",

        // Login extras
        "login.email": "E-mail",
        "login.password": "Senha",

        // Exams extras
        "exams.all_records": "Todos os Registros",
        "exams.lab_results": "Resultados Laboratoriais",
        "exams.cardiology": "Cardiologia",
        "exams.general": "Geral",
        "exams.imaging": "Imagem",
        "exams.live": "Ao Vivo",

        // Exam Detail
        "exam_detail.loading": "Carregando exame...",
        "exam_detail.title": "Detalhes do Exame",
        "exam_detail.file_preview": "Pre-visualizacao do Arquivo",
        "exam_detail.no_file": "Nenhum arquivo anexado",
        "exam_detail.details_section": "Detalhes",
        "exam_detail.type_label": "Tipo",
        "exam_detail.date_label": "Data",
        "exam_detail.created_label": "Criado",
        "exam_detail.updated_label": "Atualizado",
        "exam_detail.notes_section": "Observacoes",
        "exam_detail.delete_button": "Excluir Exame",

        // Appointments extras
        "appointments.loading": "Carregando consultas...",
        "appointments.error_title": "Nao foi possivel carregar as consultas",
        "appointments.no_appointments_title": "Sem consultas",
        "appointments.no_upcoming_message": "Voce nao tem consultas proximas.",
        "appointments.no_upcoming": "Sem consultas proximas",
        "appointments.no_past": "Sem consultas anteriores",
        "appointments.completed": "Concluida",
        "appointments.cancelled": "Cancelada",
        "appointments.schedule_new": "Agendar Nova",

        // Appointment Detail
        "appointment_detail.loading": "Carregando consulta...",
        "appointment_detail.title": "Detalhes da Consulta",
        "appointment_detail.doctor_label": "Medico",
        "appointment_detail.date_time_label": "Data e Hora",
        "appointment_detail.location_label": "Local",
        "appointment_detail.reminder_label": "Lembrete",
        "appointment_detail.minutes_before": "minutos antes",
        "appointment_detail.description_label": "Descricao",
        "appointment_detail.cancel_button": "Cancelar Consulta",

        // Profile extras
        "profile.date_of_birth": "Data de Nascimento",
        "profile.not_set": "Nao definido",
        "profile.gender": "Genero",
        "profile.height": "Altura",
        "profile.weight": "Peso",
        "profile.blood_type": "Tipo Sanguineo",
        "profile.allergies": "Alergias",
        "profile.medications": "Medicamentos",
        "profile.past_conditions": "Condicoes Anteriores",
        "profile.chronic_conditions": "Condicoes Cronicas",
        "profile.active_asthma": "Asma Ativa",
        "profile.view_all": "Ver Tudo",
        "profile.emergency_contact_placeholder": "Contato de Emergencia",
        "profile.tap_to_manage": "Toque para gerenciar",

        // Edit Profile
        "edit_profile.title": "Editar Perfil",
        "edit_profile.save_button": "Salvar Alteracoes",
        "edit_profile.change_photo": "Alterar Foto",
        "edit_profile.full_name": "Nome Completo",
        "edit_profile.email": "E-mail",
        "edit_profile.phone": "Telefone",
        "edit_profile.date_of_birth": "Data de Nascimento",
        "edit_profile.gender": "Genero",
        "edit_profile.gender_male": "Masculino",
        "edit_profile.gender_female": "Feminino",
        "edit_profile.gender_other": "Outro",
        "edit_profile.gender_prefer_not": "Prefiro nao dizer",
        "edit_profile.height_cm": "Altura (cm)",
        "edit_profile.weight_kg": "Peso (kg)",
        "edit_profile.blood_type": "Tipo Sanguineo",
        "common.select": "Selecionar",

        // Upload extras
        "upload.upload_button": "Enviar Exame",
        "upload.photo_captured": "Foto capturada",
        "upload.add_exam_title": "Adicione seu exame",
        "upload.file_types_message": "PDF, JPG, PNG ate 10MB",
        "upload.type_label": "Tipo",
        "upload.title_label": "Titulo (Opcional)",
        "upload.title_placeholder": "Opcional — a IA nomeara isso",
        "upload.exam_date_label": "Data do Exame",
        "upload.notes_label": "Observacoes",
        "common.remove": "Remover",

        // Emergency Contacts
        "emergency_contacts.loading": "Carregando contatos...",
        "emergency_contacts.error_title": "Nao foi possivel carregar os contatos",
        "emergency_contacts.no_contacts_title": "Sem Contatos de Emergencia",
        "emergency_contacts.no_contacts_message": "Adicione seus contatos de emergencia para que possam ser acionados rapidamente quando necessario.",
        "emergency_contacts.add_contact": "Adicionar Contato",
        "emergency_contacts.primary_badge": "Principal",
        "emergency_contacts.name_field": "Nome",
        "emergency_contacts.relationship_field": "Parentesco",
        "emergency_contacts.phone_field": "Telefone",
        "emergency_contacts.email_field": "E-mail",

        // Registration
        "registration.success_title": "Conta Criada",
        "registration.success_message": "Conta criada! Faca login.",
        "registration.create_account": "Criar Conta",
        "registration.subtitle": "Cadastre-se para gerenciar seus registros de saude",
        "registration.full_name": "Nome Completo",
        "registration.email": "E-mail",
        "registration.password": "Senha",
        "registration.confirm_password": "Confirmar Senha",
        "registration.agree_terms": "Concordo com os Termos de Servico",
        "registration.already_have_account": "Ja tem uma conta?",

        // Notifications
        "notifications.title": "Notificacoes",
        "notifications.loading": "Carregando notificacoes...",
        "notifications.no_notifications_title": "Sem notificacoes",
        "notifications.no_notifications_message": "Avisaremos quando algo precisar da sua atencao.",
        "notifications.time_just_now": "Agora mesmo",
        "notifications.time_yesterday": "Ontem",

        // Insights extras
        "insights.no_insights_title": "Sem analises ainda",
        "insights.no_insights_message": "As analises aparecerao conforme voce adicionar mais dados de saude.",
        "insights.metabolic_stability": "Estabilidade Metabolica",
        "insights.longevity_score_title": "Pontuacao Preditiva de Longevidade",
        "insights.longevity_score_message": "Baseado nas suas metricas de saude atuais",
        "insights.metric_sleep": "Sono",
        "insights.metric_stress": "Estresse",
        "insights.metric_activity": "Atividade",
        "insights.metric_nutrition": "Nutricao",
        "insights.recent_reports": "Relatorios Recentes",

        // Exam Categories
        "exam_category.lab": "Laboratorio",
        "exam_category.imaging": "Imagem",
        "exam_category.cardio_functional": "Cardio e Funcional",
        "exam_category.preventive_screening": "Preventivos e Rastreamento",
        "exam_category.lab_description": "Exames de sangue, bioquimica, urina, fezes",
        "exam_category.imaging_description": "Raio-X, ultrassom, ressonancia magnetica, tomografia, mamografia",
        "exam_category.cardio_functional_description": "ECG, teste de esforco, Holter, espirometria",
        "exam_category.preventive_screening_description": "Papanicolau, colonoscopia, prostata, densitometria ossea",

        // Home extras
        "home.my_health": "Minha Saude",
        "home.my_exams": "Meus Exames",
        "home.my_vaccines": "Minhas Vacinas",
        "home.medications": "Medicamentos",
        "home.appointments": "Consultas",
        "home.others": "Outros",
        "home.coming_soon": "Em breve",

        // My Health
        "my_health.title": "Minha Saude",
        "my_health.scoring_coming_soon": "Metodologia de pontuacao em breve",
        "my_health.no_exams": "Nenhum exame enviado ainda",
        "my_health.year_exams": "exames",

        // Profile diabetes/allergies
        "profile.diabetes": "Diabetes",
        "profile.has_allergies": "Alergias",
        "profile.yes": "Sim",
        "profile.no": "Nao",

        // Allergies
        "allergies.title": "Minhas Alergias",
        "allergies.add": "Adicionar Alergia",
        "allergies.name": "Nome da Alergia",
        "allergies.severity": "Gravidade",
        "allergies.notes": "Observacoes",
        "allergies.severity_low": "Baixa",
        "allergies.severity_medium": "Media",
        "allergies.severity_high": "Alta",
        "allergies.no_allergies": "Sem alergias registradas",
        "allergies.no_allergies_message": "Adicione suas alergias para mante-las em seu historico.",
        "allergies.name_placeholder": "ex., Amendoim, Penicilina",

        // Common yes/no
        "common.yes": "Sim",
        "common.no": "Nao",

        // Dashboard cards
        "dashboard.greeting": "Ola",
        "dashboard.my_health": "Minha Saude",
        "dashboard.my_exams": "Meus Exames",
        "dashboard.my_vaccines": "Minhas Vacinas",
        "dashboard.medications": "Medicamentos",
        "dashboard.appointments": "Consultas",
        "dashboard.others": "Outros",
        "dashboard.coming_soon": "Em breve",

        // Edit Profile extras
        "edit_profile.diabetes": "Diabetes",
        "edit_profile.allergies": "Alergias",
        "edit_profile.manage_allergies": "Gerenciar Alergias",

        // Upload extras
        "upload.category_label": "Categoria",

        // AI Analysis — Upload
        "upload.not_an_exam": "Este arquivo nao parece ser um documento medico e foi ignorado",
        "upload.not_an_exam_reason": "Motivo: %@",

        // AI Analysis — Exam
        "exam.ai_summary": "Resumo da IA",
        "exam.ai_analyzed_badge": "Analisado por IA",
        "exam.processing": "Analisando...",
        "exam.analysis_failed": "Falha na analise",
        "exam.reanalyze": "Reanalisar",
        "exam.lab_results": "Resultados de Laboratorio",
        "exam.prescription": "Receita",
        "exam.imaging_report": "Laudo de Imagem",
        "exam.test_name": "Exame",
        "exam.value": "Valor",
        "exam.unit": "Unidade",
        "exam.reference_range": "Faixa de Referencia",
        "exam.flag_normal": "Normal",
        "exam.flag_high": "Alto",
        "exam.flag_low": "Baixo",
        "exam.medication": "Medicamento",
        "exam.dosage": "Dosagem",
        "exam.frequency": "Frequencia",
        "exam.duration": "Duracao",
        "exam.modality": "Modalidade",
        "exam.body_part": "Parte do Corpo",
        "exam.findings": "Achados",
        "exam.impression": "Impressao",

        // AI Analysis — MyHealth / Dashboard
        "myhealth.ai_analyzed": "%d analisados por IA",
        "dashboard.from_exam": "Do seu exame mais recente",
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

        // Dashboard extras
        "dashboard.cardiovascular_message": "A sua saude cardiovascular melhorou 4% desde a sua ultima visita.",
        "dashboard.see_all": "Ver Tudo",

        // Login extras
        "login.email": "E-mail",
        "login.password": "Palavra-passe",

        // Exams extras
        "exams.all_records": "Todos os Registos",
        "exams.lab_results": "Resultados Laboratoriais",
        "exams.cardiology": "Cardiologia",
        "exams.general": "Geral",
        "exams.imaging": "Imagiologia",
        "exams.live": "Em Direto",

        // Exam Detail
        "exam_detail.loading": "A carregar exame...",
        "exam_detail.title": "Detalhes do Exame",
        "exam_detail.file_preview": "Pre-visualizacao do Ficheiro",
        "exam_detail.no_file": "Nenhum ficheiro anexado",
        "exam_detail.details_section": "Detalhes",
        "exam_detail.type_label": "Tipo",
        "exam_detail.date_label": "Data",
        "exam_detail.created_label": "Criado",
        "exam_detail.updated_label": "Atualizado",
        "exam_detail.notes_section": "Notas",
        "exam_detail.delete_button": "Eliminar Exame",

        // Appointments extras
        "appointments.loading": "A carregar consultas...",
        "appointments.error_title": "Nao foi possivel carregar as consultas",
        "appointments.no_appointments_title": "Sem consultas",
        "appointments.no_upcoming_message": "Nao tem consultas proximas.",
        "appointments.no_upcoming": "Sem consultas proximas",
        "appointments.no_past": "Sem consultas anteriores",
        "appointments.completed": "Concluida",
        "appointments.cancelled": "Cancelada",
        "appointments.schedule_new": "Marcar Nova",

        // Appointment Detail
        "appointment_detail.loading": "A carregar consulta...",
        "appointment_detail.title": "Detalhes da Consulta",
        "appointment_detail.doctor_label": "Medico",
        "appointment_detail.date_time_label": "Data e Hora",
        "appointment_detail.location_label": "Local",
        "appointment_detail.reminder_label": "Lembrete",
        "appointment_detail.minutes_before": "minutos antes",
        "appointment_detail.description_label": "Descricao",
        "appointment_detail.cancel_button": "Cancelar Consulta",

        // Profile extras
        "profile.date_of_birth": "Data de Nascimento",
        "profile.not_set": "Nao definido",
        "profile.gender": "Genero",
        "profile.height": "Altura",
        "profile.weight": "Peso",
        "profile.blood_type": "Tipo Sanguineo",
        "profile.allergies": "Alergias",
        "profile.medications": "Medicamentos",
        "profile.past_conditions": "Condicoes Anteriores",
        "profile.chronic_conditions": "Condicoes Cronicas",
        "profile.active_asthma": "Asma Ativa",
        "profile.view_all": "Ver Tudo",
        "profile.emergency_contact_placeholder": "Contacto de Emergencia",
        "profile.tap_to_manage": "Toque para gerir",

        // Edit Profile
        "edit_profile.title": "Editar Perfil",
        "edit_profile.save_button": "Guardar Alteracoes",
        "edit_profile.change_photo": "Alterar Fotografia",
        "edit_profile.full_name": "Nome Completo",
        "edit_profile.email": "E-mail",
        "edit_profile.phone": "Telefone",
        "edit_profile.date_of_birth": "Data de Nascimento",
        "edit_profile.gender": "Genero",
        "edit_profile.gender_male": "Masculino",
        "edit_profile.gender_female": "Feminino",
        "edit_profile.gender_other": "Outro",
        "edit_profile.gender_prefer_not": "Prefiro nao dizer",
        "edit_profile.height_cm": "Altura (cm)",
        "edit_profile.weight_kg": "Peso (kg)",
        "edit_profile.blood_type": "Tipo Sanguineo",
        "common.select": "Selecionar",

        // Upload extras
        "upload.upload_button": "Carregar Exame",
        "upload.photo_captured": "Fotografia capturada",
        "upload.add_exam_title": "Adicione o seu exame",
        "upload.file_types_message": "PDF, JPG, PNG ate 10MB",
        "upload.type_label": "Tipo",
        "upload.title_label": "Titulo (Opcional)",
        "upload.title_placeholder": "Opcional — a IA nomeara isto",
        "upload.exam_date_label": "Data do Exame",
        "upload.notes_label": "Notas",
        "common.remove": "Remover",

        // Emergency Contacts
        "emergency_contacts.loading": "A carregar contactos...",
        "emergency_contacts.error_title": "Nao foi possivel carregar os contactos",
        "emergency_contacts.no_contacts_title": "Sem Contactos de Emergencia",
        "emergency_contacts.no_contacts_message": "Adicione os seus contactos de emergencia para que possam ser contactados rapidamente quando necessario.",
        "emergency_contacts.add_contact": "Adicionar Contacto",
        "emergency_contacts.primary_badge": "Principal",
        "emergency_contacts.name_field": "Nome",
        "emergency_contacts.relationship_field": "Parentesco",
        "emergency_contacts.phone_field": "Telefone",
        "emergency_contacts.email_field": "E-mail",

        // Registration
        "registration.success_title": "Conta Criada",
        "registration.success_message": "Conta criada! Inicie sessao.",
        "registration.create_account": "Criar Conta",
        "registration.subtitle": "Registe-se para gerir os seus registos de saude",
        "registration.full_name": "Nome Completo",
        "registration.email": "E-mail",
        "registration.password": "Palavra-passe",
        "registration.confirm_password": "Confirmar Palavra-passe",
        "registration.agree_terms": "Concordo com os Termos de Servico",
        "registration.already_have_account": "Ja tem uma conta?",

        // Notifications
        "notifications.title": "Notificacoes",
        "notifications.loading": "A carregar notificacoes...",
        "notifications.no_notifications_title": "Sem notificacoes",
        "notifications.no_notifications_message": "Avisaremos quando algo precisar da sua atencao.",
        "notifications.time_just_now": "Agora mesmo",
        "notifications.time_yesterday": "Ontem",

        // Insights extras
        "insights.no_insights_title": "Sem analises ainda",
        "insights.no_insights_message": "As analises aparecerao a medida que adicionar mais dados de saude.",
        "insights.metabolic_stability": "Estabilidade Metabolica",
        "insights.longevity_score_title": "Pontuacao Preditiva de Longevidade",
        "insights.longevity_score_message": "Baseado nas suas metricas de saude atuais",
        "insights.metric_sleep": "Sono",
        "insights.metric_stress": "Stress",
        "insights.metric_activity": "Atividade",
        "insights.metric_nutrition": "Nutricao",
        "insights.recent_reports": "Relatorios Recentes",

        // Exam Categories
        "exam_category.lab": "Laboratorio",
        "exam_category.imaging": "Imagiologia",
        "exam_category.cardio_functional": "Cardio e Funcional",
        "exam_category.preventive_screening": "Preventivos e Rastreio",
        "exam_category.lab_description": "Analises de sangue, bioquimica, urina, fezes",
        "exam_category.imaging_description": "Raio-X, ecografia, ressonancia magnetica, tomografia, mamografia",
        "exam_category.cardio_functional_description": "ECG, prova de esforco, Holter, espirometria",
        "exam_category.preventive_screening_description": "Papanicolau, colonoscopia, prostata, densitometria ossea",

        // Home extras
        "home.my_health": "A Minha Saude",
        "home.my_exams": "Os Meus Exames",
        "home.my_vaccines": "As Minhas Vacinas",
        "home.medications": "Medicamentos",
        "home.appointments": "Consultas",
        "home.others": "Outros",
        "home.coming_soon": "Em breve",

        // My Health
        "my_health.title": "A Minha Saude",
        "my_health.scoring_coming_soon": "Metodologia de pontuacao em breve",
        "my_health.no_exams": "Ainda nao foram carregados exames",
        "my_health.year_exams": "exames",

        // Profile diabetes/allergies
        "profile.diabetes": "Diabetes",
        "profile.has_allergies": "Alergias",
        "profile.yes": "Sim",
        "profile.no": "Nao",

        // Allergies
        "allergies.title": "As Minhas Alergias",
        "allergies.add": "Adicionar Alergia",
        "allergies.name": "Nome da Alergia",
        "allergies.severity": "Gravidade",
        "allergies.notes": "Notas",
        "allergies.severity_low": "Baixa",
        "allergies.severity_medium": "Media",
        "allergies.severity_high": "Alta",
        "allergies.no_allergies": "Sem alergias registadas",
        "allergies.no_allergies_message": "Adicione as suas alergias para as manter no seu registo.",
        "allergies.name_placeholder": "ex., Amendoim, Penicilina",

        // Common yes/no
        "common.yes": "Sim",
        "common.no": "Nao",

        // Dashboard cards
        "dashboard.greeting": "Ola",
        "dashboard.my_health": "A Minha Saude",
        "dashboard.my_exams": "Os Meus Exames",
        "dashboard.my_vaccines": "As Minhas Vacinas",
        "dashboard.medications": "Medicacao",
        "dashboard.appointments": "Consultas",
        "dashboard.others": "Outros",
        "dashboard.coming_soon": "Em breve",

        // Edit Profile extras
        "edit_profile.diabetes": "Diabetes",
        "edit_profile.allergies": "Alergias",
        "edit_profile.manage_allergies": "Gerir Alergias",

        // Upload extras
        "upload.category_label": "Categoria",

        // AI Analysis — Upload
        "upload.not_an_exam": "Este ficheiro nao parece ser um documento medico e foi ignorado",
        "upload.not_an_exam_reason": "Motivo: %@",

        // AI Analysis — Exam
        "exam.ai_summary": "Resumo da IA",
        "exam.ai_analyzed_badge": "Analisado por IA",
        "exam.processing": "A analisar...",
        "exam.analysis_failed": "Falha na analise",
        "exam.reanalyze": "Reanalisar",
        "exam.lab_results": "Resultados de Laboratorio",
        "exam.prescription": "Receita",
        "exam.imaging_report": "Relatorio de Imagem",
        "exam.test_name": "Exame",
        "exam.value": "Valor",
        "exam.unit": "Unidade",
        "exam.reference_range": "Intervalo de Referencia",
        "exam.flag_normal": "Normal",
        "exam.flag_high": "Alto",
        "exam.flag_low": "Baixo",
        "exam.medication": "Medicamento",
        "exam.dosage": "Dosagem",
        "exam.frequency": "Frequencia",
        "exam.duration": "Duracao",
        "exam.modality": "Modalidade",
        "exam.body_part": "Parte do Corpo",
        "exam.findings": "Achados",
        "exam.impression": "Impressao",

        // AI Analysis — MyHealth / Dashboard
        "myhealth.ai_analyzed": "%d analisados por IA",
        "dashboard.from_exam": "Do seu exame mais recente",
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

        // Dashboard extras
        "dashboard.cardiovascular_message": "Votre sante cardiovasculaire s'est amelioree de 4% depuis votre derniere visite.",
        "dashboard.see_all": "Tout Voir",

        // Login extras
        "login.email": "E-mail",
        "login.password": "Mot de passe",

        // Exams extras
        "exams.all_records": "Tous les Dossiers",
        "exams.lab_results": "Resultats de Laboratoire",
        "exams.cardiology": "Cardiologie",
        "exams.general": "General",
        "exams.imaging": "Imagerie",
        "exams.live": "En Direct",

        // Exam Detail
        "exam_detail.loading": "Chargement de l'examen...",
        "exam_detail.title": "Details de l'Examen",
        "exam_detail.file_preview": "Apercu du Fichier",
        "exam_detail.no_file": "Aucun fichier joint",
        "exam_detail.details_section": "Details",
        "exam_detail.type_label": "Type",
        "exam_detail.date_label": "Date",
        "exam_detail.created_label": "Cree",
        "exam_detail.updated_label": "Mis a jour",
        "exam_detail.notes_section": "Notes",
        "exam_detail.delete_button": "Supprimer l'Examen",

        // Appointments extras
        "appointments.loading": "Chargement des rendez-vous...",
        "appointments.error_title": "Impossible de charger les rendez-vous",
        "appointments.no_appointments_title": "Aucun rendez-vous",
        "appointments.no_upcoming_message": "Vous n'avez pas de rendez-vous a venir.",
        "appointments.no_upcoming": "Aucun rendez-vous a venir",
        "appointments.no_past": "Aucun rendez-vous passe",
        "appointments.completed": "Termine",
        "appointments.cancelled": "Annule",
        "appointments.schedule_new": "Nouveau Rendez-vous",

        // Appointment Detail
        "appointment_detail.loading": "Chargement du rendez-vous...",
        "appointment_detail.title": "Details du Rendez-vous",
        "appointment_detail.doctor_label": "Medecin",
        "appointment_detail.date_time_label": "Date et Heure",
        "appointment_detail.location_label": "Lieu",
        "appointment_detail.reminder_label": "Rappel",
        "appointment_detail.minutes_before": "minutes avant",
        "appointment_detail.description_label": "Description",
        "appointment_detail.cancel_button": "Annuler le Rendez-vous",

        // Profile extras
        "profile.date_of_birth": "Date de Naissance",
        "profile.not_set": "Non defini",
        "profile.gender": "Genre",
        "profile.height": "Taille",
        "profile.weight": "Poids",
        "profile.blood_type": "Groupe Sanguin",
        "profile.allergies": "Allergies",
        "profile.medications": "Medicaments",
        "profile.past_conditions": "Antecedents Medicaux",
        "profile.chronic_conditions": "Maladies Chroniques",
        "profile.active_asthma": "Asthme Actif",
        "profile.view_all": "Tout Voir",
        "profile.emergency_contact_placeholder": "Contact d'Urgence",
        "profile.tap_to_manage": "Appuyez pour gerer",

        // Edit Profile
        "edit_profile.title": "Modifier le Profil",
        "edit_profile.save_button": "Enregistrer les Modifications",
        "edit_profile.change_photo": "Changer la Photo",
        "edit_profile.full_name": "Nom Complet",
        "edit_profile.email": "E-mail",
        "edit_profile.phone": "Telephone",
        "edit_profile.date_of_birth": "Date de Naissance",
        "edit_profile.gender": "Genre",
        "edit_profile.gender_male": "Homme",
        "edit_profile.gender_female": "Femme",
        "edit_profile.gender_other": "Autre",
        "edit_profile.gender_prefer_not": "Je prefere ne pas dire",
        "edit_profile.height_cm": "Taille (cm)",
        "edit_profile.weight_kg": "Poids (kg)",
        "edit_profile.blood_type": "Groupe Sanguin",
        "common.select": "Selectionner",

        // Upload extras
        "upload.upload_button": "Telecharger l'Examen",
        "upload.photo_captured": "Photo capturee",
        "upload.add_exam_title": "Ajoutez votre examen",
        "upload.file_types_message": "PDF, JPG, PNG jusqu'a 10 Mo",
        "upload.type_label": "Type",
        "upload.title_label": "Titre (Facultatif)",
        "upload.title_placeholder": "Facultatif — l'IA le nommera",
        "upload.exam_date_label": "Date de l'Examen",
        "upload.notes_label": "Notes",
        "common.remove": "Supprimer",

        // Emergency Contacts
        "emergency_contacts.loading": "Chargement des contacts...",
        "emergency_contacts.error_title": "Impossible de charger les contacts",
        "emergency_contacts.no_contacts_title": "Aucun Contact d'Urgence",
        "emergency_contacts.no_contacts_message": "Ajoutez vos contacts d'urgence afin qu'ils puissent etre joints rapidement en cas de besoin.",
        "emergency_contacts.add_contact": "Ajouter un Contact",
        "emergency_contacts.primary_badge": "Principal",
        "emergency_contacts.name_field": "Nom",
        "emergency_contacts.relationship_field": "Lien de parente",
        "emergency_contacts.phone_field": "Telephone",
        "emergency_contacts.email_field": "E-mail",

        // Registration
        "registration.success_title": "Compte Cree",
        "registration.success_message": "Compte cree ! Veuillez vous connecter.",
        "registration.create_account": "Creer un Compte",
        "registration.subtitle": "Inscrivez-vous pour gerer vos dossiers de sante",
        "registration.full_name": "Nom Complet",
        "registration.email": "E-mail",
        "registration.password": "Mot de passe",
        "registration.confirm_password": "Confirmer le Mot de passe",
        "registration.agree_terms": "J'accepte les Conditions d'Utilisation",
        "registration.already_have_account": "Vous avez deja un compte ?",

        // Notifications
        "notifications.title": "Notifications",
        "notifications.loading": "Chargement des notifications...",
        "notifications.no_notifications_title": "Aucune notification",
        "notifications.no_notifications_message": "Nous vous informerons lorsque quelque chose necessite votre attention.",
        "notifications.time_just_now": "A l'instant",
        "notifications.time_yesterday": "Hier",

        // Insights extras
        "insights.no_insights_title": "Aucune analyse pour le moment",
        "insights.no_insights_message": "Les analyses apparaitront au fur et a mesure que vous ajouterez des donnees de sante.",
        "insights.metabolic_stability": "Stabilite Metabolique",
        "insights.longevity_score_title": "Score Predictif de Longevite",
        "insights.longevity_score_message": "Base sur vos metriques de sante actuelles",
        "insights.metric_sleep": "Sommeil",
        "insights.metric_stress": "Stress",
        "insights.metric_activity": "Activite",
        "insights.metric_nutrition": "Nutrition",
        "insights.recent_reports": "Rapports Recents",

        // Exam Categories
        "exam_category.lab": "Laboratoire",
        "exam_category.imaging": "Imagerie",
        "exam_category.cardio_functional": "Cardio et Fonctionnel",
        "exam_category.preventive_screening": "Preventif et Depistage",
        "exam_category.lab_description": "Analyses de sang, biochimie, urine, selles",
        "exam_category.imaging_description": "Radiographie, echographie, IRM, scanner, mammographie",
        "exam_category.cardio_functional_description": "ECG, epreuve d'effort, Holter, spirometrie",
        "exam_category.preventive_screening_description": "Frottis, coloscopie, prostate, osteodensitometrie",

        // Home extras
        "home.my_health": "Ma Sante",
        "home.my_exams": "Mes Examens",
        "home.my_vaccines": "Mes Vaccins",
        "home.medications": "Medicaments",
        "home.appointments": "Consultations",
        "home.others": "Autres",
        "home.coming_soon": "Bientot",

        // My Health
        "my_health.title": "Ma Sante",
        "my_health.scoring_coming_soon": "Methodologie de notation bientot disponible",
        "my_health.no_exams": "Aucun examen telecharge",
        "my_health.year_exams": "examens",

        // Profile diabetes/allergies
        "profile.diabetes": "Diabete",
        "profile.has_allergies": "Allergies",
        "profile.yes": "Oui",
        "profile.no": "Non",

        // Allergies
        "allergies.title": "Mes Allergies",
        "allergies.add": "Ajouter une Allergie",
        "allergies.name": "Nom de l'Allergie",
        "allergies.severity": "Severite",
        "allergies.notes": "Notes",
        "allergies.severity_low": "Faible",
        "allergies.severity_medium": "Moyenne",
        "allergies.severity_high": "Elevee",
        "allergies.no_allergies": "Aucune allergie enregistree",
        "allergies.no_allergies_message": "Ajoutez vos allergies pour les garder dans votre dossier.",
        "allergies.name_placeholder": "ex., Cacahuetes, Penicilline",

        // Common yes/no
        "common.yes": "Oui",
        "common.no": "Non",

        // Dashboard cards
        "dashboard.greeting": "Bonjour",
        "dashboard.my_health": "Ma Sante",
        "dashboard.my_exams": "Mes Examens",
        "dashboard.my_vaccines": "Mes Vaccins",
        "dashboard.medications": "Medicaments",
        "dashboard.appointments": "Rendez-vous",
        "dashboard.others": "Autres",
        "dashboard.coming_soon": "Bientot Disponible",

        // Edit Profile extras
        "edit_profile.diabetes": "Diabete",
        "edit_profile.allergies": "Allergies",
        "edit_profile.manage_allergies": "Gerer les Allergies",

        // Upload extras
        "upload.category_label": "Categorie",

        // AI Analysis — Upload
        "upload.not_an_exam": "Ce fichier ne semble pas etre un document medical et a ete ignore",
        "upload.not_an_exam_reason": "Raison: %@",

        // AI Analysis — Exam
        "exam.ai_summary": "Resume IA",
        "exam.ai_analyzed_badge": "Analyse par IA",
        "exam.processing": "Analyse en cours...",
        "exam.analysis_failed": "Echec de l'analyse",
        "exam.reanalyze": "Reanalyser",
        "exam.lab_results": "Resultats de Laboratoire",
        "exam.prescription": "Ordonnance",
        "exam.imaging_report": "Rapport d'Imagerie",
        "exam.test_name": "Test",
        "exam.value": "Valeur",
        "exam.unit": "Unite",
        "exam.reference_range": "Plage de Reference",
        "exam.flag_normal": "Normal",
        "exam.flag_high": "Eleve",
        "exam.flag_low": "Bas",
        "exam.medication": "Medicament",
        "exam.dosage": "Dosage",
        "exam.frequency": "Frequence",
        "exam.duration": "Duree",
        "exam.modality": "Modalite",
        "exam.body_part": "Partie du Corps",
        "exam.findings": "Constatations",
        "exam.impression": "Impression",

        // AI Analysis — MyHealth / Dashboard
        "myhealth.ai_analyzed": "%d analyses par IA",
        "dashboard.from_exam": "De votre dernier examen",
    ]
}
// swiftlint:enable file_length type_body_length
