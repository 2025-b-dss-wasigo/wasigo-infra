# WasiGo Infrastructure

Repositorio de infraestructura cloud-native para el **backend de WasiGo**, desplegado en **Azure** con enfoque en **bajo costo**, **aprendizaje DevOps**, **GitOps** y **control de recursos**.

Este repositorio **NO contiene código de la aplicación**, únicamente **infraestructura Azure**, **configuración de Kubernetes** y **automatización operativa**.

---

## 🛠 Stack Tecnológico

### Infraestructura & Cloud

- **Azure Kubernetes Service (AKS)**
- **Azure Container Registry (ACR)**
- **Azure CLI**
- **Terraform** (Infraestructura como Código)

### Kubernetes & Operación

- **Kubernetes**
- **kubectl**
- **Helm**
- **ArgoCD** (GitOps)
- **Ansible** (automatización operativa)

---

## 🎯 Objetivo

- Desplegar un entorno Kubernetes **real y funcional** para el backend.
- Aplicar **Infraestructura como Código (IaC)** con Terraform.
- Implementar **GitOps** para despliegues controlados.
- Minimizar el consumo de créditos (**Azure for Students**).
- Separar claramente **infraestructura**, **operación** y **aplicación**.
- Preparar la base para **seguridad, observabilidad y escalabilidad**.

---

## 🏗 Arquitectura General

- **Resource Group:** `rg-wasigo-dev`
- **AKS:** Cluster Kubernetes con **1 nodo apagable** (`Standard_B2s`)
- **ACR:** Registro privado de imágenes Docker
- **Namespaces:**
  - `argocd`
  - `backend`
  - `ingress`
  - `observability`

La arquitectura está diseñada para **escalar horizontalmente** en entornos productivos, manteniendo un tamaño reducido para fines académicos.

---

## ⚙️ Flujo de Configuración

### 1. Inicialización de Terraform

Terraform se utiliza para preparar proveedores y estado.

```bash
cd terraform
terraform init
```

## 2. Creación de Infraestructura Base en Azure

Se crean los recursos base necesarios para el entorno:

- Resource Group
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Permisos **ACR Pull** para AKS (Managed Identity)

```bash
terraform plan
terraform apply
```

### 3. Conexión Local con el Cluster AKS

Se obtienen las credenciales del cluster para operar con kubectl.

```bash
az aks get-credentials \
  --resource-group rg-wasigo-dev \
  --name aks-wasigo-dev
```

Verificar el estado del cluster:

```bash
kubectl get nodes
```

### 4. Organización Inicial del Cluster

Creación de namespaces base para aislar responsabilidades:

```bash
kubectl create namespace argocd
kubectl create namespace backend
kubectl create namespace ingress
kubectl create namespace observability
```

Verificar namespaces existentes:

```bash
kubectl get ns
```

### 5. Control de Costos del Cluster 💰

El cluster se mantiene apagado fuera del horario de trabajo para evitar consumo innecesario de créditos.

Encender el cluster:

```bash
az aks start \
 --name aks-wasigo-dev \
 --resource-group rg-wasigo-dev
```

Apagar el cluster (al finalizar la sesión):

```bash
az aks stop \
 --name aks-wasigo-dev \
 --resource-group rg-wasigo-dev
```

## 🔁 GitOps y Automatización

### GitOps (ArgoCD)

ArgoCD se utiliza para desplegar y sincronizar los siguientes componentes:

- PostgreSQL (CloudNativePG)
- Redis
- MinIO
- Backend API
- Ingress Controller

Todo el **estado deseado del cluster vive en Git**, y ArgoCD es el **único componente con acceso directo a Kubernetes** para aplicar cambios.

---

### Automatización Operativa (Ansible)

Ansible se utiliza como capa complementaria para:

- Bootstrap post-provisión del cluster.
- Tareas operativas _day-2_ (backups, validaciones, restores).
- Ejecución de checks antes de demos o evaluaciones académicas.

---

## ✅ Buenas Prácticas Aplicadas

- Infraestructura versionada con Terraform.
- Separación clara de responsabilidades:
  - **Terraform** → Azure
  - **GitOps (ArgoCD)** → Kubernetes
  - **Ansible** → Operación
- Cluster AKS apagable para ahorro de costos.
- Uso de identidades administradas (Managed Identity).
- Registro privado de imágenes (ACR).
- Namespaces para aislamiento lógico.

---

## 📂 Separación de Repositorios

- `wasigo-infra` → infraestructura, Kubernetes y automatización
- `wasigo-backend` → API (backend)
- `wasigo-frontend` → cliente web (otro repositorio)

---

## 📌 Estado Actual

- Infraestructura base desplegada en Azure
- AKS operativo (1 nodo)
- ACR integrado con AKS
- Conectividad local con `kubectl`
- Namespaces base creados
- Instalación de ArgoCD
- Despliegue de servicios core (PostgreSQL, Redis, MinIO)
- Configuración de Ingress y HTTPS

---

## 🚀 Próximos Pasos

1. Instalar **ArgoCD**
2. Configurar **Nginx Ingress Controller**
3. Desplegar **PostgreSQL con CloudNativePG**
4. Desplegar backend vía GitOps
5. Habilitar HTTPS con Cert-Manager
6. Añadir observabilidad básica

---

> Este repositorio forma parte de un **proyecto académico y de portafolio**, diseñado para demostrar prácticas DevOps reales utilizando **Azure for Students**, priorizando el control de costos y la escalabilidad del diseño.
