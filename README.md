# WasiGo Infrastructure

Repositorio de infraestructura cloud-native para el **backend de WasiGo**, desplegado en **Azure** con enfoque en **bajo costo**, **aprendizaje DevOps** y **control de recursos**.

Este repositorio **NO contiene código de la aplicación**, únicamente infraestructura y configuración de Kubernetes.

---

## 🛠 Stack Tecnológico

- **Azure Kubernetes Service (AKS)**
- **Azure Container Registry (ACR)**
- **Terraform** (Infraestructura como Código)
- **Kubernetes**
- **Azure CLI**
- **kubectl**

---

## 🎯 Objetivo

- Desplegar un entorno Kubernetes real para el backend.
- Usar Infraestructura como Código (IaC).
- Minimizar el consumo de créditos (Azure for Students).
- Separar infraestructura, backend y frontend.
- Preparar la base para módulos de seguridad.

---

## 🏗 Arquitectura General

- **Resource Group:** Contenedor lógico del proyecto.
- **ACR:** Almacenamiento privado de imágenes Docker.
- **AKS:** Cluster Kubernetes con 1 nodo apagable.
- **Namespace `backend`:** Aislamiento lógico del backend.

---

## ⚙️ Flujo de Configuración

### 1. Inicialización de Terraform

Terraform se utiliza para inicializar los proveedores y preparar el entorno.

```bash
cd terraform
terraform init
```

### 2. Creación de Infraestructura Base

Se crean los recursos definidos (Resource Group, ACR, AKS).

```bash
terraform plan
terraform apply
```

### 3. Gestión del Cluster AKS (Control de Costos 💰)

El cluster se enciende únicamente cuando se trabaja activamente.

Encender:

```bash
az aks start --name aks-wasigo-dev --resource-group rg-wasigo-dev
```

Apagar (Al finalizar la sesión): Para evitar consumo innecesario de créditos.

```bash
az aks stop --name aks-wasigo-dev --resource-group rg-wasigo-dev
```

### 4. Conexión Local con Kubernetes

Se obtienen las credenciales del cluster para permitir el uso de kubectl.

```bash
az aks get-credentials --resource-group rg-wasigo-dev --name aks-wasigo-dev
```

Verificar el contexto activo:

```bash
kubectl config get-contexts
```

### 5. Verificación del Estado del Cluster

Confirmar que el nodo está activo y listo.

```bash
kubectl get nodes
```

### 6. Organización del Cluster (Namespaces)

Se crea un namespace dedicado para el backend.

```bash
kubectl create namespace backend
```

Verificar namespaces existentes:

```bash
kubectl get ns
```

### 7. Conexión entre AKS y ACR

Se autoriza al cluster AKS a descargar imágenes privadas desde ACR.

```bash
az aks update \
  --name aks-wasigo-dev \
  --resource-group rg-wasigo-dev \
  --attach-acr wasigodevacr
```

## Buenas Prácticas Aplicadas

- Infraestructura versionada con Terraform
- Cluster AKS apagable para ahorro de costos
- Separación lógica de recursos mediante namespaces
- Uso de registro privado de imágenes (ACR)
- Autenticación mediante identidades administradas (Managed Identity)

---

## Separación de Repositorios

- `wasigo-infra` → infraestructura y configuración de Kubernetes
- `wasigo-backend` → API (NestJS)
- `wasigo-frontend` → cliente web (gestionado por otro integrante)

---

## Estado Actual

- Infraestructura base desplegada en Azure
- AKS funcional y validado
- Namespace `backend` creado
- AKS autorizado para consumir imágenes desde ACR
- Entorno listo para el despliegue del backend

---

## Próximos Pasos

- Dockerizar el backend
- Subir la imagen al Azure Container Registry
- Crear `Deployment` y `Service` en Kubernetes
- Configurar Ingress Controller
- Exponer la API mediante una URL pública

---

> Este flujo está diseñado para entornos académicos y de aprendizaje, utilizando **Azure for Students** y priorizando el control de costos.
