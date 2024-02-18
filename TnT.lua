local function soustraireListes(L1, L2) -- Soustrais les éléments de L2 présents dans L1 à L1
    local resultat = {}
    local elements_L2 = {}

    for _, v in ipairs(L2) do
        elements_L2[v[1] .. "," .. v[2]] = true
    end

    for _, v in ipairs(L1) do
        local key = v[1] .. "," .. v[2]
        if not elements_L2[key] then
            table.insert(resultat, v)
        end
    end

    return resultat
end

local function genereCouples(n) -- Génère un tableau n x n 
    local couples = {}
    for i = 1, n do
        for j = 1, n do
            table.insert(couples, {i, j})
        end
    end
    return couples
end

local function obtenirOrthogonaux(couple) -- Renvoie les couples orthogonaux à un autre couple
    local i = couple[1]
    local j = couple[2]
    local orthogonaux = {}
    local directions = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}
    
    for _, dir in ipairs(directions) do
        local new_i, new_j = i + dir[1], j + dir[2]
        table.insert(orthogonaux, {new_i, new_j})
    end
    
    return orthogonaux
end

local function obtenirAdjacents(couple) -- Renvoie les couples adjacents à un autre couple
    local i = couple[1]
    local j = couple[2]
    local adjacents = {}
    local directions = {{-1, -1}, {-1, 0}, {-1, 1}, {0, 0}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
    
    for _, dir in ipairs(directions) do
        local new_i, new_j = i + dir[1], j + dir[2]
        table.insert(adjacents, {new_i, new_j})
    end
    
    return adjacents
end

local function obtenirTentes(tableau)

  local tableTents = tableau
  local rand1
  local rand2
  local tents = {}
  local trees = {}
  local possibleTent
  local possibleTrees
  local adjacents
  local orthogonaux
  local tampon

  while #tableTents ~= 0 do

    rand1 = math.random(1,#tableTents)
    possibleTent = tableTents[rand1]
    orthogonaux = obtenirOrthogonaux(possibleTent)
    tampon = soustraireListes(orthogonaux,tableau)
    orthogonaux = soustraireListes(orthogonaux,tampon)

    if #orthogonaux > 0 then
      rand2 = math.random(1,#orthogonaux)
      table.insert(trees,orthogonaux[rand2])
      table.insert(tents, possibleTent)
      adjacents = obtenirAdjacents(possibleTent)
      tableTents = soustraireListes(tableTents,adjacents)
    end

  end
  return tents,trees

end

local function genereIndices(tents,n)
  local lignes = {}
  local colonnes = {}

  for i = 1, n do
    lignes[i] = 0
    colonnes[i] = 0
  end

  for _, couple in ipairs(tents) do
    local i = couple[1]
    local j = couple[2]
    lignes[i] = lignes[i] + 1
    colonnes[j] = colonnes[j] + 1
  end

  return lignes,colonnes

end

local function genereGrille(n)

  local tableau = genereCouples(n)
  local tents,trees = obtenirTentes(tableau)
  local lignes,colonnes= genereIndices(tents,n)
  local grille = {}

  for i=1,n+1 do 
    grille[i] = {}
    for j=1,n+1 do
      grille[i][j] = 'V'
    end
  end

  for k=1,n do
    grille[1][k+1] = colonnes[k]
    grille[k+1][1] = lignes[k]
  end

  for i = 1, n do 
      for j = 1, n do
          -- Vérifier si la coordonnée est dans la liste de tentes
          for _, tent in ipairs(tents) do
              if tent[1] == i and tent[2] == j then
                  grille[i+1][j+1] = 'T'  -- Modifier la valeur de la grille à cette coordonnée par 1
              end
          end
          -- Vérifier si la coordonnée est dans la liste d'arbres
          for _, tree in ipairs(trees) do
              if tree[1] == i and tree[2] == j then
                  grille[i+1][j+1] = 'A'  -- Modifier la valeur de la grille à cette coordonnée par 2
              end
          end
      end
  end

  return grille

end

-- Affichage de la grille dans la console
local function printGrille(grille)
    local str = ""
    for i = 1, #grille do
        for j = 1, #grille[i] do
            str = str .. grille[i][j] .. "\t"
        end
        str = str .. "\n"
    end
    print(str)
end

return{
  genereGrille = genereGrille,
  printGrille = printGrille,
}