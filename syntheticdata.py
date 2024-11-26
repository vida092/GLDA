import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


def generate_equilateral_triangle(A, d):

    n = len(A)
    u = np.random.randn(n)
    u /= np.linalg.norm(u)  
    B = A + d * u

    v = np.random.randn(n)
    v -= np.dot(v, u) * u  
    v /= np.linalg.norm(v) 

    v *= (np.sqrt(3) * d) / 2
    
    C = A + (d / 2) * u + v
    return [A, B, C]

def generate_random_cov_matrix(dim):
    A = np.random.rand(dim, dim) 
    A = (A + A.T) / 2  

    eigvals, eigvecs = np.linalg.eigh(A) 
    eigvals = np.clip(eigvals, a_min=0.1, a_max=None)  
    A = eigvecs @ np.diag(eigvals) @ eigvecs.T  

    diag_vals = np.sqrt(np.diag(A))  
    scaling_matrix = np.diag(1 / diag_vals) 
    cov_matrix = scaling_matrix @ A @ scaling_matrix  
    cov_matrix = (cov_matrix + cov_matrix.T) / 2

    return cov_matrix



def dbtype_1_2(n_samples, n_features, means, cov_matrix, n_classes):

    all_samples = []
    all_labels = []
    
    for i in range(n_classes):
        samples = np.random.multivariate_normal(means[i], cov_matrix, n_samples)
        labels = np.full(n_samples, i)
        all_samples.append(samples)
        all_labels.append(labels)
    
    X = np.vstack(all_samples)
    y = np.hstack(all_labels)
    data = pd.DataFrame(X, columns=[f"Feature_{j+1}" for j in range(n_features)])
    data['Class'] = y
    
    return data


def dbtype_3_4(n_samples, n_features, means, n_classes):

    all_samples = []
    all_labels = []
    
    for i in range(n_classes):
        samples = np.random.multivariate_normal(means[i], generate_random_cov_matrix(n_features), n_samples)
        labels = np.full(n_samples, i)
        all_samples.append(samples)
        all_labels.append(labels)
    
    X = np.vstack(all_samples)
    y = np.hstack(all_labels)
    data = pd.DataFrame(X, columns=[f"Feature_{j+1}" for j in range(n_features)])
    data['Class'] = y
    
    return data

def dbtype_5_6(n_samples, n_features, means, n_classes, distribution="laplace"):
    cov_matrix = generate_random_cov_matrix(n_features)  
    all_samples = []
    all_labels = []

    for i in range(n_classes):
        if distribution == "laplace":
            samples = np.random.laplace(loc=means[i], scale=1.0, size=(n_samples, n_features))
        elif distribution == "cauchy":
            samples = np.random.standard_cauchy(size=(n_samples, n_features)) + means[i]
        elif distribution == "uniform":
            samples = np.random.uniform(-1, 1, size=(n_samples, n_features)) + means[i]
        else:
            raise ValueError("Distribución no soportada. Use 'laplace', 'cauchy', o 'uniform'.")

        # Transformar los datos para tener la misma covarianza
        transform_matrix = np.linalg.cholesky(cov_matrix)
        samples = np.dot(samples, transform_matrix.T)
        
        # Etiquetas
        labels = np.full(n_samples, i)
        
        all_samples.append(samples)
        all_labels.append(labels)

    X = np.vstack(all_samples)
    y = np.hstack(all_labels)
    data = pd.DataFrame(X, columns=[f"Feature_{j+1}" for j in range(n_features)])
    data['Class'] = y

    return data

def dbtype_7_8(n_samples, n_features, n_classes, range_min=-10, range_max=10, distribution="uniform"):
    all_samples = []
    all_labels = []

    for i in range(n_classes):
        if distribution == "uniform":
            samples = np.random.uniform(range_min + i**2**0.5, range_max - i*7, size=(n_samples, n_features))
        elif distribution == "normal":
            samples = np.random.normal(0, 1, size=(n_samples, n_features))   
        else:
            raise ValueError("Distribución no soportada. Use 'uniform' o 'normal'.")
        
        
        labels = np.full(n_samples, i)
        all_samples.append(samples)
        all_labels.append(labels)

    X = np.vstack(all_samples)
    y = np.hstack(all_labels)
    data = pd.DataFrame(X, columns=[f"Feature_{j+1}" for j in range(n_features)])
    data['Class'] = y

    return data

def scatter_3d(df, col_x, col_y, col_z):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    class_col = df.columns[-1]
    classes = df[class_col].unique()
    for c in classes:
        subset = df[df[class_col] == c]
        ax.scatter(subset[col_x], subset[col_y], subset[col_z], label=f'Class {int(c)}', alpha=0.6)

    ax.set_xlabel(col_x)
    ax.set_ylabel(col_y)
    ax.set_zlabel(col_z)
    ax.legend()
    plt.show()

############ Datasets1 y 2 ##############
n_samples = 100
n_features = 5
d = 5
means = generate_equilateral_triangle(np.zeros(n_features), d)


cov_matrix = generate_random_cov_matrix(n_features)
data = dbtype_1_2(n_samples,n_features,means,cov_matrix,3)

scatter_3d(data, data.columns[0], data.columns[1], data.columns[4])

data.to_csv("data1.csv", index=False)



n_samples = 50
n_features = 100
d =15
mean_class1 = np.random.rand(n_features)
mean_class2 = np.zeros(n_features) + np.random.rand(n_features) + 1.5
mean_class3 = np.zeros(n_features) - np.random.rand(n_features) - 1.5
means = generate_equilateral_triangle(np.zeros(n_features), d)
cov_matrix = generate_random_cov_matrix(n_features)
data2 = dbtype_1_2(n_samples,n_features,means,cov_matrix,3)

data2.to_csv("data2.csv", index=False)


scatter_3d(data2, data2.columns[1], data2.columns[25], data2.columns[3])


############### datasets 3 y 4 ###############

n_samples = 100
n_features = 5
mean_class1 = np.zeros(n_features)
mean_class2 = np.zeros(n_features) + np.random.rand(n_features) + 2.5
mean_class3 = np.zeros(n_features) - np.random.rand(n_features) - 1.9
data3 = dbtype_3_4(n_samples, n_features, [mean_class1,mean_class2,mean_class3], 3)

data3.to_csv("data3.csv", index=False)

scatter_3d(data3, data3.columns[1], data3.columns[4], data3.columns[3])


n_samples = 30
n_features = 100
mean_class1 = np.zeros(n_features)
mean_class2 = np.zeros(n_features) + np.random.rand(n_features) + 1.5
mean_class3 = np.zeros(n_features) - np.random.rand(n_features) - 1.4
data4 = dbtype_3_4(n_samples, n_features, [mean_class1,mean_class2,mean_class3], 3)

data4.to_csv("data4.csv", index=False)

scatter_3d(data4, data4.columns[1], data4.columns[4], data4.columns[3])


####### Datasets 5 y 6  #############

n_samples = 100
n_features = 6
mean_class1 = np.zeros(n_features)
mean_class2 = np.zeros(n_features) + np.random.rand(n_features) + 0.35
mean_class3 = np.zeros(n_features) - np.random.rand(n_features) - 0.5

data5 = dbtype_5_6(n_samples, n_features,[mean_class1, mean_class2, mean_class3] , 3, "uniform")

data5.to_csv("data5.csv", index=False)

scatter_3d(data5, data5.columns[1], data5.columns[2], data5.columns[3])

n_samples = 30
n_features = 100
mean_class1 = np.zeros(n_features)
mean_class2 = np.zeros(n_features) + np.random.rand(n_features) + 0.15
mean_class3 = np.zeros(n_features) - np.random.rand(n_features) - 0.09

data6 = dbtype_5_6(n_samples, n_features,[mean_class1, mean_class2, mean_class3] , 3, "uniform")

data6.to_csv("data6.csv", index=False)

scatter_3d(data6, data6.columns[1], data6.columns[4], data6.columns[3])


##########Data set 7 ########

n_samples = 100
n_features = 5

data7 = dbtype_7_8(n_samples, n_features, 3, range_min=-10, range_max=10, distribution="uniform")

data7.to_csv("data7.csv", index=False)

scatter_3d(data7, data7.columns[1], data7.columns[4], data7.columns[3])


###### Dataset 8 #############


def generate_points_uniform_in_sphere(center, radius, num_points):
    """
    Generar puntos uniformemente distribuidos dentro de una esfera.
    """
    points = []
    for _ in range(num_points):
        vec = np.random.normal(0, 1, len(center))  # Vector aleatorio en R^n
        vec /= np.linalg.norm(vec)  # Normalizar a un vector unitario
        r = np.random.uniform(0, radius)  # Escalar con radio aleatorio
        points.append(center + r * vec)
    return np.array(points)

def generate_points_uniform_on_surface(center, radius, num_points):
    """
    Generar puntos uniformemente distribuidos sobre la superficie de una esfera.
    """
    points = []
    for _ in range(num_points):
        vec = np.random.normal(0, 1, len(center))  # Vector aleatorio en R^n
        vec /= np.linalg.norm(vec)  # Normalizar a un vector unitario
        points.append(center + radius * vec)
    return np.array(points)

def generate_points_near_surface(center, radius, num_points):
    """
    Generar puntos concentrados cerca de la superficie de una esfera usando distribución beta.
    """
    points = []
    for _ in range(num_points):
        vec = np.random.normal(0, 1, len(center))  # Vector aleatorio en R^n
        vec /= np.linalg.norm(vec)  # Normalizar a un vector unitario
        r = radius * np.random.beta(5, 2)  # Concentrar radio cerca del borde
        points.append(center + r * vec)
    return np.array(points)

# Parámetros
d=4
k = 110
A = np.zeros(k)
centers = generate_equilateral_triangle(A, d)  # Centros de las esferas
radii = [1.5, 2, 1]  # Radios de las esferas
num_points_per_sphere = 26  # Número de puntos por clase

# Generar puntos para cada esfera con diferentes distribuciones
points_class_1 = generate_points_uniform_on_surface(centers[0], radii[0], num_points_per_sphere)
points_class_2 = generate_points_uniform_on_surface(centers[1], radii[1], num_points_per_sphere)
points_class_3 = generate_points_uniform_on_surface(centers[1], radii[1], num_points_per_sphere)



def points_to_dataframe(points, label):
    """
    Convertir puntos y etiquetas en un DataFrame.
    """
    df = pd.DataFrame(points, columns=[f"Dim{i+1}" for i in range(points.shape[1])])
    df['Label'] = label
    return df



# Crear DataFrames para cada clase
df_class_1 = points_to_dataframe(points_class_1, "1")
df_class_2 = points_to_dataframe(points_class_2, "2")
df_class_3 = points_to_dataframe(points_class_3, "3")

# Combinar los DataFrames en uno solo
df_combined = pd.concat([df_class_1, df_class_2, df_class_3], ignore_index=True)
df_combined.to_csv("data8.csv",index=False)

