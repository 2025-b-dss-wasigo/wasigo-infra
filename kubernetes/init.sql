    -- =====================================================
    -- WASIGO DATABASE INIT SCRIPT (CNPG + ARGO SAFE)
    -- =====================================================
    -- Ejecutado como SUPERUSER (postgres)
    -- Roles creados y gestionados por CloudNativePG
    -- =====================================================

    -- =====================================================
    -- 1. EXTENSIONES (UUID)
    -- =====================================================
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp'
      ) THEN
        CREATE EXTENSION "uuid-ossp";
      END IF;
    END
    $$;

    -- =====================================================
    -- 2. SCHEMAS (OWNERSHIP CLARO)
    -- =====================================================
    CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION wasigo_migrator;
    CREATE SCHEMA IF NOT EXISTS business AUTHORIZATION wasigo_migrator;
    CREATE SCHEMA IF NOT EXISTS audit AUTHORIZATION wasigo_migrator;

    -- =====================================================
    -- 3. PERMISOS DE CONEXIÓN
    -- =====================================================
    GRANT CONNECT ON DATABASE wasigo TO wasigo_app;
    -- wasigo_migrator es owner del DB (bootstrap CNPG)

    -- =====================================================
    -- 4. PUBLIC SCHEMA (UUID + MIGRATIONS)
    -- =====================================================
    GRANT USAGE ON SCHEMA public TO wasigo_app, wasigo_migrator;
    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO wasigo_app, wasigo_migrator;
    GRANT CREATE ON SCHEMA public TO wasigo_migrator;

    -- =====================================================
    -- 5. PERMISOS DE LA APP (OBJETOS EXISTENTES)
    -- =====================================================

    -- AUTH
    GRANT USAGE ON SCHEMA auth TO wasigo_app;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA auth TO wasigo_app;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA auth TO wasigo_app;

    -- BUSINESS
    GRANT USAGE ON SCHEMA business TO wasigo_app;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA business TO wasigo_app;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA business TO wasigo_app;

    -- AUDIT (solo lectura + inserción)
    GRANT USAGE ON SCHEMA audit TO wasigo_app;
    GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA audit TO wasigo_app;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA audit TO wasigo_app;

    -- =====================================================
    -- 6. DEFAULT PRIVILEGES (OBJETOS FUTUROS)
    -- =====================================================
    -- NOTA: los GRANT ON ALL aplican SOLO a objetos existentes
    -- El acceso FUTURO se controla aquí

    -- ---------- AUTH ----------
    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA auth
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA auth
    GRANT USAGE, SELECT ON SEQUENCES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA auth
    GRANT SELECT ON TABLES TO wasigo_app; -- views

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA auth
    GRANT EXECUTE ON FUNCTIONS TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA auth
    GRANT USAGE ON TYPES TO wasigo_app;

    -- ---------- BUSINESS ----------
    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA business
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA business
    GRANT USAGE, SELECT ON SEQUENCES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA business
    GRANT SELECT ON TABLES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA business
    GRANT EXECUTE ON FUNCTIONS TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA business
    GRANT USAGE ON TYPES TO wasigo_app;

    -- ---------- AUDIT ----------
    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA audit
    GRANT SELECT, INSERT ON TABLES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA audit
    GRANT USAGE, SELECT ON SEQUENCES TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA audit
    GRANT EXECUTE ON FUNCTIONS TO wasigo_app;

    ALTER DEFAULT PRIVILEGES FOR ROLE wasigo_migrator IN SCHEMA audit
    GRANT USAGE ON TYPES TO wasigo_app;

    -- =====================================================
    -- 7. SEARCH_PATH (ANTI BUGS FANTASMA)
    -- =====================================================
    ALTER ROLE wasigo_app
    SET search_path = auth, business, audit, public;

    ALTER ROLE wasigo_migrator
    SET search_path = auth, business, audit, public;

    -- =====================================================
    -- 8. HARDENING FINAL
    -- =====================================================
    REVOKE CREATE ON SCHEMA public FROM PUBLIC;
    REVOKE ALL ON DATABASE wasigo FROM PUBLIC;