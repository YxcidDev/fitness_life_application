# Fitness Life Calories

![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue)
![n8n](https://img.shields.io/badge/n8n-Automation-orange)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green)

## Tabla de contenidos

- [Descripción del proyecto](#descripción-del-proyecto)
- [Características](#características)
- [Arquitectura del sistema](#arquitectura-del-sistema)
- [Configuración del proyecto](#configuración-del-proyecto)
  - [Variables de entorno](#variables-de-entorno)
  - [Base de datos (Supabase)](#configuración-de-supabase-base-de-datos)
  - [n8n (orquestador IA)](#configuración-de-n8n-ia-orquestador)
- [Instalación](#instalación)
- [Uso](#uso)
- [Flujo del sistema](#flujo-del-sistema)

## Descripción del proyecto

Fitness Life es una aplicación móvil multiplataforma que da solución al tedioso proceso manual del conteo de calorías mediante inteligencia artificial multimodal. El usuario toma o selecciona una foto de su plato de comida, y la aplicación proporciona un desglose nutricional completo, mostrando calorías totales, macronutrientes y el análisis de cada ingrediente.

## Características

- **Análisis multimodal de comidas**: identificación visual de ingredientes y cálculo automático de calorías, proteínas, carbohidratos y grasas a partir de fotografías.
- **Dashboard integrado**: panel principal para el seguimiento de metas diarias de macronutrientes.
- **Autenticación y perfiles**: gestión segura de acceso y preferencias del usuario (objetivos físicos, peso, altura) protegida con Row Level Security (RLS) en Supabase.
- **Historial nutricional**: registro detallado de todos los platos consumidos, organizados por tipo de comida (desayuno, almuerzo, cena, snacks).
- **Arquitectura desacoplada**: uso de n8n como orquestador, separando completamente la app móvil del servicio de IA.
- **Clean Architecture**: capas de dominio, datos y presentación bien definidas, con BLoC para el manejo de estados.
- **Motor de IA**: Gemini 2.5 Flash (Google AI Studio) para visión computacional y valoración nutricional.

---

## Arquitectura del sistema

El proyecto sigue el patrón **Clean Architecture**, dividido en tres capas principales:

```txt
lib/
├── app/
├── core/
│   ├── supabase/
│   ├── theme/
│   └── widgets/
└── features/
    └── feature/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            ├── screens/
            └── widgets/
```

### Capas

- **Domain** → lógica de negocio (entities, use cases)
- **Data** → fuentes de datos, modelos y repositorios
- **Presentation** → UI y gestión de estado (BLoC)

---

## Configuración del proyecto

### Requisitos previos

Antes de ejecutar el proyecto asegúrate de tener instalado:

- Flutter SDK (última versión estable)
- Dart SDK
- Cuenta en Supabase
- Instancia de n8n (Cloud o self-hosted)
- API Key de Google Gemini (AI Studio)
- Proyecto en Firebase con Cloud Messaging habilitado

### Variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
SUPABASE_URL=tu_supabase_project_url
SUPABASE_ANON_KEY=tu_supabase_anon_key
```

### Configuración de Supabase (Base de datos)

Accede al **SQL Editor de Supabase** y ejecuta el siguiente script para crear la estructura del sistema.

```sql
-- Perfiles de usuario
create table public.user_profiles (
  id          uuid references auth.users(id) on delete cascade primary key,
  full_name   text not null,
  sex         text check (sex in ('male', 'female')) not null,
  age         integer not null,
  weight_kg   numeric(5,2) not null,
  height_cm   numeric(5,2) not null,
  goal        text check (goal in ('lose_weight','gain_muscle','maintain','improve_performance')) not null,
  created_at  timestamptz default now()
);

-- Comidas analizadas
create table public.meals (
  id          uuid default gen_random_uuid() primary key,
  user_id     uuid references public.user_profiles(id) on delete cascade not null,
  meal_type   text check (meal_type in ('breakfast','lunch','dinner','snack')) not null,
  meal_name   text not null,
  image_url   text,
  calories    numeric(7,2) not null default 0,
  proteins    numeric(6,2) not null default 0,
  carbs       numeric(6,2) not null default 0,
  fats        numeric(6,2) not null default 0,
  analyzed_at timestamptz default now()
);

-- Ingredientes por comida
create table public.meal_items (
  id         uuid default gen_random_uuid() primary key,
  meal_id    uuid references public.meals(id) on delete cascade not null,
  name       text not null,
  grams      numeric(6,2) not null default 0,
  calories   numeric(7,2) not null default 0,
  proteins   numeric(6,2) not null default 0,
  carbs      numeric(6,2) not null default 0,
  fats       numeric(6,2) not null default 0
);

-- Metas nutricionales diarias
create table public.daily_goals (
  id             uuid default gen_random_uuid() primary key,
  user_id        uuid references public.user_profiles(id) on delete cascade unique not null,
  calories_goal  numeric(7,2) not null,
  proteins_goal  numeric(6,2) not null,
  carbs_goal     numeric(6,2) not null,
  fats_goal      numeric(6,2) not null,
  updated_at     timestamptz default now()
);

-- Dispositivos y tokens FCM para notificaciones push
CREATE TABLE public.user_devices (
    id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id     uuid        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    fcm_token   text        NOT NULL,
    platform    text        CHECK (platform IN ('android', 'ios', 'web')),
    device_name text,
    is_active   boolean     DEFAULT true,
    created_at  timestamptz DEFAULT now(),
    updated_at  timestamptz DEFAULT now()
);

-- Índices
create index idx_meals_user_date on public.meals(user_id, analyzed_at);

CREATE INDEX idx_user_devices_user_id
    ON public.user_devices(user_id) WHERE is_active = true;

CREATE UNIQUE INDEX idx_user_devices_token
    ON public.user_devices(user_id, fcm_token);

CREATE INDEX idx_user_devices_token_lookup
    ON public.user_devices(fcm_token);

-- Row Level Security
alter table public.user_profiles enable row level security;
alter table public.meals          enable row level security;
alter table public.meal_items     enable row level security;
alter table public.daily_goals    enable row level security;
ALTER TABLE public.user_devices   ENABLE ROW LEVEL SECURITY;

create policy "usuario ve su perfil"   on public.user_profiles for all using (auth.uid() = id);
create policy "usuario ve sus comidas" on public.meals          for all using (auth.uid() = user_id);
create policy "usuario ve sus items"   on public.meal_items     for all using (
  meal_id in (select id from public.meals where user_id = auth.uid())
);
create policy "usuario ve sus metas"   on public.daily_goals    for all using (auth.uid() = user_id);

CREATE POLICY "usuario_ve_sus_dispositivos"      ON public.user_devices FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "usuario_inserta_sus_dispositivos" ON public.user_devices FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "usuario_actualiza_sus_dispositivos" ON public.user_devices FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "usuario_elimina_sus_dispositivos" ON public.user_devices FOR DELETE USING (auth.uid() = user_id);

-- Trigger updated_at para user_devices
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_user_devices_updated_at
    BEFORE UPDATE ON public.user_devices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función upsert de token FCM (usada por Flutter)
CREATE OR REPLACE FUNCTION upsert_fcm_token(
    p_user_id   uuid,
    p_fcm_token text,
    p_platform  text,
    p_device    text DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    INSERT INTO public.user_devices (user_id, fcm_token, platform, device_name, is_active)
    VALUES (p_user_id, p_fcm_token, p_platform, p_device, true)
    ON CONFLICT (user_id, fcm_token)
    DO UPDATE SET
        is_active   = true,
        platform    = EXCLUDED.platform,
        device_name = COALESCE(EXCLUDED.device_name, user_devices.device_name),
        updated_at  = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Configuración de n8n (IA Orquestador)

1. Importa el workflow desde la carpeta `/n8n`
2. Configura las credenciales de **Google Gemini API**
3. Activa el workflow
4. Copia la URL del Webhook generado
5. Pégala en el proyecto Flutter (servicio HTTP)

#### Workflows disponibles

| Workflow | Trigger | Descripción |
|---|---|---|
| `Meal Analysis` | Webhook HTTP POST | Análisis nutricional multimodal vía imagen |
| `Meal Recommendation` | Webhook HTTP POST | Recomendación de recetas según macros restantes |
| `Breakfast Push Reminder` | Cron `0 8 * * *` | Recordatorio de desayuno |
| `Lunch Push Reminder` | Cron `0 13 * * *` | Recordatorio de almuerzo |
| `Dinner Push Reminder` | Cron `0 20 * * *` | Recordatorio de cena |

### Verificación de configuración

Una vez configurado todo, verifica que:

- Flutter puede conectarse a Supabase
- El `.env` está correctamente cargado
- El webhook de n8n responde correctamente
- Gemini API está activa y funcional

---

## Instalación

Clona el repositorio e instala las dependencias:

```bash
git clone https://github.com/YxcidDev/fitness_life_application.git
cd fitness_life_application
flutter pub get
```

---

## Uso

Ejecuta la aplicación en modo desarrollo:

```bash
flutter run
```

### Generar APK (producción)

```bash
flutter build apk --release
```

---

## Flujo del sistema

### Workflow: Meal Analysis

1. El usuario toma una foto de su comida desde la app
2. La imagen se convierte a Base64
3. Flutter envía la imagen a un webhook de n8n
4. n8n procesa la imagen y la envía a Gemini AI
5. La IA identifica alimentos y calcula macronutrientes
6. n8n estructura la respuesta en formato JSON
7. Flutter recibe la respuesta
8. La UI se actualiza con el análisis nutricional

### Workflow: Meal Recommendation

1. Flutter envía el ID del usuario e ingredientes disponibles
2. n8n consulta Supabase para obtener metas diarias y consumo acumulado
3. Un nodo Code calcula los macros restantes y el tipo de comida según la hora
4. Gemini genera una receta contextual personalizada
5. Structured Output Parser transforma la salida
6. Flutter renderiza la recomendación en un Bottom Sheet

### Workflow: Notification Push

1. Schedule Trigger activa el workflow en el horario configurado
2. Execute SQL Query identifica usuarios sin la comida del día registrada
3. Se obtienen sus tokens FCM activos desde `user_devices`
4. Loop Over Items itera cada dispositivo
5. HTTP Request envía la notificación a la API de Firebase Cloud Messaging
6. Google FCM distribuye el recordatorio push al dispositivo del usuario

