##### Consultas traducidas al algebra relacional



###### Consulta 1: Top 5 selecciones con más goles marcados 



```

w = ρs(MORENOLUIS.fifa\_seleccion) ⨝ s.id\_seleccion = pp.id\_seleccion ρpp(MORENOLUIS.fifa\_participacion\_partido)



τ goles\_totales DESC ( π pais, goles\_totales ( σ goles\_totales>3 ( γ pais; SUM(goles\_marcados) AS goles\_totales (w) ) ) )



```



###### Consulta 2: Porcentaje de ocupación estimado por estadio:



```

ρe(morenoluis.fifa\_estadio) ⨝ e.id\_estadio = p.id\_estadio ρp(morenoluis.fifa\_partido) = w



τ ocupacion\_pct DESC (γ nombre,ciudad,capacidad; COUNT(id\_partido) AS partidos\_jugados; ROUND(AVG((asistencia\_registrada/capacidad)\*100),2) AS ocupacion\_pct (w))

```

###### Consulta 4: Partidos jugados por fase 



```

τ num\_partidos DESC (γ fase; COUNT(id\_partido) AS num\_partidos (morenoluis.fifa\_partido))

```

###### 

###### Consulta 8: Estadios sobre el promedio de ocupacion



```

w = ρe(MORENOLUIS.fifa\_estadio) ⨝ e.id\_estadio = p.id\_estadio ρp(MORENOLUIS.fifa\_partido)



z = ρz( γ nombre,ciudad; ROUND(AVG((asistencia\_registrada/capacidad)\*100),2) AS ocupacion\_pct (w) )



y = ρy( γ ; ROUND(AVG((asistencia\_registrada/capacidad)\*100),2) AS ocupacion\_pct (w) )



π nombre,ciudad,ocupacion\_pct ( σ z.ocupacion\_pct > y.ocupacion\_pct (z × y) )

```



