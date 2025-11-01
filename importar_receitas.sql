-- =====================================================
-- SCRIPT SQL - FITCHEF IA
-- Banco de Dados: Supabase (PostgreSQL)
-- =====================================================

-- 1. CRIAR EXTENSÃO PARA UUID (se ainda não existir)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. CRIAR TABELA DE RECEITAS
DROP TABLE IF EXISTS receitas CASCADE;

CREATE TABLE receitas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome TEXT NOT NULL,
  ingredientes TEXT[] NOT NULL,
  modo_preparo TEXT NOT NULL,
  macros JSONB,
  categoria TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. CRIAR ÍNDICES PARA MELHOR PERFORMANCE
CREATE INDEX idx_receitas_ingredientes ON receitas USING GIN(ingredientes);
CREATE INDEX idx_receitas_categoria ON receitas(categoria);
CREATE INDEX idx_receitas_nome ON receitas(nome);

-- 4. POPULAR TABELA COM RECEITAS ANABÓLICAS

-- CATEGORIA: CAFÉ DA MANHÃ
INSERT INTO receitas (nome, ingredientes, modo_preparo, macros, categoria) VALUES
(
  'Panqueca de Aveia com Whey',
  ARRAY['aveia', 'ovo', 'whey', 'banana', 'canela'],
  '1. Bata 40g de aveia, 2 ovos, 1 scoop de whey, 1/2 banana e canela no liquidificador.
2. Aqueça uma frigideira antiaderente.
3. Despeje a massa e cozinhe em fogo baixo até dourar dos dois lados.
4. Sirva com a outra metade da banana fatiada por cima.',
  '{"kcal": 380, "p": 35, "c": 42, "g": 8}'::jsonb,
  'Café da Manhã'
),
(
  'Omelete Proteica de Claras',
  ARRAY['ovo', 'queijo-cottage', 'espinafre', 'tomate', 'cebola'],
  '1. Separe 4 claras e 1 gema.
2. Bata as claras com a gema e tempere com sal e pimenta.
3. Refogue espinafre, tomate e cebola picados.
4. Despeje os ovos na frigideira e adicione 2 colheres de queijo cottage.
5. Dobre a omelete ao meio quando estiver firme.',
  '{"kcal": 220, "p": 28, "c": 8, "g": 7}'::jsonb,
  'Café da Manhã'
),
(
  'Mingau de Aveia Anabólico',
  ARRAY['aveia', 'leite-desnatado', 'whey', 'pasta-de-amendoim', 'banana'],
  '1. Cozinhe 50g de aveia com 200ml de leite desnatado.
2. Quando engrossar, desligue o fogo e adicione 1 scoop de whey.
3. Misture bem e coloque em um bowl.
4. Adicione 1 colher de pasta de amendoim e banana fatiada por cima.',
  '{"kcal": 420, "p": 32, "c": 48, "g": 12}'::jsonb,
  'Café da Manhã'
),
(
  'Crepioca Fitness',
  ARRAY['tapioca', 'ovo', 'queijo-minas'],
  '1. Misture 2 colheres de goma de tapioca com 2 ovos inteiros.
2. Bata bem até ficar homogêneo.
3. Despeje em frigideira antiaderente aquecida.
4. Quando firmar de um lado, vire e adicione queijo minas light.
5. Dobre ao meio e sirva.',
  '{"kcal": 250, "p": 20, "c": 22, "g": 9}'::jsonb,
  'Café da Manhã'
),

-- CATEGORIA: ALMOÇO
(
  'Frango Grelhado com Batata Doce',
  ARRAY['frango', 'batata-doce', 'brócolis', 'azeite'],
  '1. Tempere 200g de peito de frango com sal, pimenta, alho e ervas.
2. Grelhe o frango em frigideira com um fio de azeite.
3. Cozinhe 150g de batata-doce no vapor ou água.
4. Cozinhe o brócolis no vapor por 5 minutos.
5. Sirva tudo junto e regue com azeite de oliva.',
  '{"kcal": 380, "p": 42, "c": 35, "g": 6}'::jsonb,
  'Almoço'
),
(
  'Arroz Integral com Carne Moída',
  ARRAY['arroz-integral', 'carne-moída', 'cenoura', 'vagem', 'cebola', 'alho'],
  '1. Cozinhe 80g de arroz integral.
2. Refogue cebola e alho picados.
3. Adicione 150g de carne moída magra (patinho) e doure.
4. Adicione cenoura e vagem picadas.
5. Tempere com sal, pimenta e salsinha. Sirva com o arroz.',
  '{"kcal": 420, "p": 35, "c": 45, "g": 10}'::jsonb,
  'Almoço'
),
(
  'Salmão com Purê de Batata Doce',
  ARRAY['salmão', 'batata-doce', 'aspargos', 'limão'],
  '1. Tempere 180g de filé de salmão com sal, pimenta e limão.
2. Grelhe o salmão por 4 minutos de cada lado.
3. Cozinhe 200g de batata-doce e amasse com um pouco de leite.
4. Grelhe os aspargos rapidamente com azeite.
5. Sirva o salmão sobre o purê com aspargos ao lado.',
  '{"kcal": 450, "p": 38, "c": 40, "g": 14}'::jsonb,
  'Almoço'
),
(
  'Macarrão Integral com Frango e Brócolis',
  ARRAY['macarrão-integral', 'frango', 'brócolis', 'tomate', 'azeite', 'alho'],
  '1. Cozinhe 80g de macarrão integral al dente.
2. Grelhe 150g de frango em cubos temperados.
3. Cozinhe brócolis no vapor e reserve.
4. Refogue alho no azeite, adicione tomates picados.
5. Misture tudo: macarrão, frango, brócolis e molho.',
  '{"kcal": 410, "p": 38, "c": 48, "g": 8}'::jsonb,
  'Almoço'
),

-- CATEGORIA: JANTAR
(
  'Tilápia com Legumes no Vapor',
  ARRAY['tilápia', 'abobrinha', 'cenoura', 'brócolis', 'limão'],
  '1. Tempere 200g de filé de tilápia com limão, sal e ervas.
2. Cozinhe no vapor por 10 minutos.
3. Corte abobrinha e cenoura em rodelas.
4. Cozinhe os legumes no vapor por 8 minutos.
5. Sirva o peixe com os legumes e regue com azeite.',
  '{"kcal": 280, "p": 40, "c": 15, "g": 6}'::jsonb,
  'Jantar'
),
(
  'Omelete de Claras com Queijo Cottage',
  ARRAY['ovo', 'queijo-cottage', 'tomate', 'orégano'],
  '1. Bata 5 claras com sal e orégano.
2. Despeje em frigideira antiaderente.
3. Adicione tomate picado e 3 colheres de queijo cottage.
4. Dobre a omelete e sirva com salada verde.',
  '{"kcal": 180, "p": 28, "c": 6, "g": 4}'::jsonb,
  'Jantar'
),
(
  'Salada de Atum Proteica',
  ARRAY['atum', 'ovo', 'alface', 'tomate', 'pepino', 'azeite', 'limão'],
  '1. Cozinhe 2 ovos por 10 minutos e pique.
2. Misture 1 lata de atum em água drenado.
3. Pique alface, tomate e pepino.
4. Misture tudo e tempere com azeite, limão, sal e pimenta.',
  '{"kcal": 320, "p": 35, "c": 8, "g": 16}'::jsonb,
  'Jantar'
),

-- CATEGORIA: LANCHES
(
  'Shake Proteico de Banana',
  ARRAY['banana', 'whey', 'leite-desnatado', 'pasta-de-amendoim', 'gelo'],
  '1. Coloque no liquidificador: 1 banana, 1 scoop de whey, 200ml de leite desnatado.
2. Adicione 1 colher de pasta de amendoim e 4 cubos de gelo.
3. Bata até ficar cremoso e sirva imediatamente.',
  '{"kcal": 380, "p": 32, "c": 38, "g": 10}'::jsonb,
  'Lanche'
),
(
  'Sanduíche Natural de Frango',
  ARRAY['pão-integral', 'frango', 'alface', 'tomate', 'queijo-minas'],
  '1. Desfie 100g de frango cozido e tempere.
2. Monte o sanduíche: pão integral, alface, tomate, frango desfiado e queijo minas.
3. Pode adicionar mostarda ou iogurte natural como molho.',
  '{"kcal": 320, "p": 28, "c": 32, "g": 8}'::jsonb,
  'Lanche'
),
(
  'Bolinho de Atum Fit',
  ARRAY['atum', 'batata-doce', 'ovo', 'aveia'],
  '1. Amasse 150g de batata-doce cozida.
2. Misture 1 lata de atum drenado, 1 ovo e 2 colheres de aveia.
3. Tempere com sal, pimenta e salsinha.
4. Forme bolinhos e asse por 20 minutos a 180°C.',
  '{"kcal": 280, "p": 26, "c": 28, "g": 6}'::jsonb,
  'Lanche'
),
(
  'Barrinha Proteica Caseira',
  ARRAY['aveia', 'whey', 'pasta-de-amendoim', 'mel', 'castanhas'],
  '1. Misture 100g de aveia, 2 scoops de whey, 3 colheres de pasta de amendoim.
2. Adicione 2 colheres de mel e castanhas picadas.
3. Adicione água aos poucos até dar liga.
4. Coloque em forma, pressione bem e leve à geladeira por 2 horas.
5. Corte em barrinhas.',
  '{"kcal": 180, "p": 12, "c": 18, "g": 7}'::jsonb,
  'Lanche'
),

-- CATEGORIA: PRÉ-TREINO
(
  'Bowl de Açaí Proteico',
  ARRAY['açaí', 'banana', 'whey', 'granola', 'morango'],
  '1. Bata 100g de polpa de açaí com 1/2 banana e 1/2 scoop de whey.
2. Coloque em um bowl.
3. Adicione por cima: banana fatiada, morangos, 2 colheres de granola sem açúcar.',
  '{"kcal": 320, "p": 15, "c": 48, "g": 8}'::jsonb,
  'Pré-treino'
),
(
  'Batata Doce com Frango Desfiado',
  ARRAY['batata-doce', 'frango', 'requeijão-light'],
  '1. Asse 200g de batata-doce no forno por 40 minutos.
2. Desfie 100g de frango cozido e tempere.
3. Abra a batata-doce ao meio.
4. Recheie com o frango e 1 colher de requeijão light.',
  '{"kcal": 350, "p": 28, "c": 42, "g": 6}'::jsonb,
  'Pré-treino'
),
(
  'Overnight Oats Proteico',
  ARRAY['aveia', 'iogurte-grego', 'whey', 'frutas-vermelhas', 'chia'],
  '1. Na noite anterior, misture: 50g de aveia, 150g de iogurte grego, 1/2 scoop de whey.
2. Adicione 1 colher de sementes de chia.
3. Deixe na geladeira durante a noite.
4. Pela manhã, adicione frutas vermelhas por cima.',
  '{"kcal": 340, "p": 28, "c": 38, "g": 8}'::jsonb,
  'Pré-treino'
),

-- CATEGORIA: PÓS-TREINO
(
  'Vitamina de Abacate com Whey',
  ARRAY['abacate', 'whey', 'leite-desnatado', 'banana', 'cacau'],
  '1. Bata no liquidificador: 1/2 abacate pequeno, 1 scoop de whey chocolate.
2. Adicione 250ml de leite desnatado, 1/2 banana e 1 colher de cacau em pó.
3. Bata com gelo e sirva imediatamente.',
  '{"kcal": 420, "p": 32, "c": 35, "g": 16}'::jsonb,
  'Pós-treino'
),
(
  'Wrap de Frango com Cottage',
  ARRAY['tortilha-integral', 'frango', 'queijo-cottage', 'alface', 'tomate'],
  '1. Aqueça uma tortilha integral.
2. Espalhe 2 colheres de queijo cottage.
3. Adicione 120g de frango grelhado em tiras.
4. Coloque alface e tomate.
5. Enrole bem e corte ao meio.',
  '{"kcal": 340, "p": 35, "c": 28, "g": 8}'::jsonb,
  'Pós-treino'
),
(
  'Smoothie Bowl Proteico',
  ARRAY['banana', 'whey', 'espinafre', 'leite-de-amêndoas', 'aveia', 'amêndoas'],
  '1. Bata: 1 banana congelada, 1 scoop de whey vanilla, punhado de espinafre, 150ml leite de amêndoas.
2. Despeje em um bowl.
3. Decore com: aveia, amêndoas fatiadas, banana em rodelas.',
  '{"kcal": 380, "p": 30, "c": 42, "g": 10}'::jsonb,
  'Pós-treino'
),

-- CATEGORIA: SOBREMESAS FIT
(
  'Mousse de Chocolate Proteico',
  ARRAY['abacate', 'whey', 'cacau', 'leite-de-coco', 'stevia'],
  '1. Bata 1 abacate maduro com 2 scoops de whey chocolate.
2. Adicione 3 colheres de cacau em pó e 100ml de leite de coco.
3. Adoce com stevia a gosto.
4. Leve à geladeira por 2 horas antes de servir.',
  '{"kcal": 280, "p": 20, "c": 18, "g": 14}'::jsonb,
  'Sobremesa'
),
(
  'Brownie Fit de Batata Doce',
  ARRAY['batata-doce', 'cacau', 'ovo', 'whey', 'pasta-de-amendoim'],
  '1. Amasse 200g de batata-doce cozida.
2. Misture: 3 colheres de cacau, 2 ovos, 1 scoop de whey chocolate, 2 colheres de pasta de amendoim.
3. Coloque em forma untada.
4. Asse por 25 minutos a 180°C.',
  '{"kcal": 220, "p": 15, "c": 24, "g": 8}'::jsonb,
  'Sobremesa'
),
(
  'Pudim de Chia Proteico',
  ARRAY['chia', 'leite-de-amêndoas', 'whey', 'morango', 'coco-ralado'],
  '1. Misture 3 colheres de chia com 200ml de leite de amêndoas.
2. Adicione 1/2 scoop de whey vanilla e mexa bem.
3. Deixe na geladeira por 4 horas ou durante a noite.
4. Sirva com morangos picados e coco ralado.',
  '{"kcal": 240, "p": 16, "c": 20, "g": 10}'::jsonb,
  'Sobremesa'
),

-- CATEGORIA: RECEITAS RÁPIDAS (5 MINUTOS)
(
  'Shake Express Pós-Treino',
  ARRAY['whey', 'banana', 'aveia', 'água'],
  '1. Coloque todos os ingredientes no liquidificador: 1 scoop de whey, 1 banana, 2 colheres de aveia, 200ml de água gelada.
2. Bata por 30 segundos e sirva.',
  '{"kcal": 280, "p": 26, "c": 38, "g": 3}'::jsonb,
  'Rápida'
),
(
  'Sanduíche de Atum Express',
  ARRAY['pão-integral', 'atum', 'cottage'],
  '1. Torre 2 fatias de pão integral.
2. Misture 1 lata de atum com 2 colheres de cottage.
3. Espalhe no pão e sirva.',
  '{"kcal": 260, "p": 28, "c": 26, "g": 4}'::jsonb,
  'Rápida'
),
(
  'Mix de Nuts Proteico',
  ARRAY['castanha-do-pará', 'amêndoas', 'nozes', 'whey'],
  '1. Misture 30g de nuts variadas com 1/2 scoop de whey.
2. Adicione um pouco de água para o whey grudar nas castanhas.
3. Consuma imediatamente.',
  '{"kcal": 320, "p": 18, "c": 12, "g": 22}'::jsonb,
  'Rápida'
);

-- 5. CRIAR FUNÇÃO PARA BUSCAR RECEITAS POR INGREDIENTES
CREATE OR REPLACE FUNCTION buscar_receitas_por_ingredientes(ingredientes_busca TEXT[])
RETURNS TABLE(
  id UUID,
  nome TEXT,
  ingredientes TEXT[],
  modo_preparo TEXT,
  macros JSONB,
  categoria TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT r.id, r.nome, r.ingredientes, r.modo_preparo, r.macros, r.categoria
  FROM receitas r
  WHERE r.ingredientes @> ingredientes_busca  -- Contém todos os ingredientes buscados
     OR r.ingredientes && ingredientes_busca;  -- Ou tem interseção com os ingredientes
END;
$$ LANGUAGE plpgsql;

-- 6. CRIAR VIEW PARA ESTATÍSTICAS
CREATE OR REPLACE VIEW estatisticas_receitas AS
SELECT 
  categoria,
  COUNT(*) as total_receitas,
  AVG((macros->>'kcal')::int) as media_calorias,
  AVG((macros->>'p')::int) as media_proteinas
FROM receitas
GROUP BY categoria;

-- 7. CONFIGURAR ROW LEVEL SECURITY (RLS) - OPCIONAL
-- Descomente se quiser usar RLS no Supabase

-- ALTER TABLE receitas ENABLE ROW LEVEL SECURITY;

-- CREATE POLICY "Permitir leitura pública de receitas"
-- ON receitas FOR SELECT
-- TO public
-- USING (true);

-- 8. GRANT PERMISSIONS (necessário no Supabase)
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON receitas TO anon, authenticated;
GRANT EXECUTE ON FUNCTION buscar_receitas_por_ingredientes TO anon, authenticated;

-- =====================================================
-- FIM DO SCRIPT
-- Total de receitas inseridas: 30
-- Categorias: Café da Manhã, Almoço, Jantar, Lanche, 
--             Pré-treino, Pós-treino, Sobremesa, Rápida
-- =====================================================