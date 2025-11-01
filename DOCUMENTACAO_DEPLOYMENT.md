# 📚 DOCUMENTAÇÃO FITCHEF IA - DEPLOYMENT COMPLETO

## 🎯 Visão Geral
FitChef IA é uma aplicação web que permite aos usuários encontrar receitas fitness baseadas nos ingredientes disponíveis. O sistema usa n8n como backend serverless e Supabase como banco de dados.

---

## 🏗️ Arquitetura do Sistema

```
[Frontend Web] → [n8n Webhook] → [Supabase DB] → [Response JSON]
     ↓                                              ↑
[HTML/JS/CSS]                                [Receitas Fitness]
```

---

## 📋 Pré-requisitos

1. **Conta Supabase** (gratuita): https://supabase.com
2. **Conta n8n** (gratuita): https://n8n.io ou self-hosted
3. **Conta Vercel/Netlify** (gratuita): Para hospedar o frontend
4. **OpenAI API Key** (opcional): Para sugestões via IA

---

## 🚀 PASSO A PASSO DE CONFIGURAÇÃO

### PASSO 1: CONFIGURAR SUPABASE

1. **Criar Projeto no Supabase:**
   - Acesse https://app.supabase.com
   - Clique em "New Project"
   - Nome: `fitchef-ia`
   - Senha do banco: (anote esta senha)
   - Região: Escolha a mais próxima

2. **Executar Script SQL:**
   - No painel do Supabase, vá para "SQL Editor"
   - Cole todo o conteúdo do arquivo `importar_receitas.sql`
   - Clique em "Run" para executar
   - Aguarde confirmação "Success"

3. **Obter Credenciais:**
   - Vá em "Settings" → "API"
   - Copie:
     - `Project URL`: https://xxxxx.supabase.co
     - `anon public`: eyJhbGc...
   - Guarde estas informações

4. **Testar Banco:**
   ```sql
   SELECT * FROM receitas LIMIT 5;
   ```

### PASSO 2: CONFIGURAR N8N

1. **Criar Conta n8n Cloud (Recomendado):**
   - Acesse https://n8n.io
   - Crie conta gratuita
   - Ou instale self-hosted: https://docs.n8n.io/hosting/

2. **Importar Workflow:**
   - No n8n, clique em "Workflows" → "Add workflow"
   - Clique nos 3 pontos → "Import from file"
   - Faça upload do arquivo `n8n-workflow-fitchef.json`

3. **Configurar Variáveis de Ambiente:**
   - No n8n, vá em Settings → Variables
   - Adicione:
     ```
     SUPABASE_URL = https://xxxxx.supabase.co
     SUPABASE_KEY = eyJhbGc...
     ```

4. **Configurar Nó OpenAI (Opcional):**
   - Se tiver API Key da OpenAI
   - Clique no nó "GPT Sugestões"
   - Add Credentials → OpenAI API
   - Cole sua API Key

5. **Ativar Workflow:**
   - Clique em "Inactive" para mudar para "Active"
   - Copie a URL do webhook:
     ```
     https://seu-usuario.app.n8n.cloud/webhook/fitchef
     ```

### PASSO 3: CONFIGURAR FRONTEND

1. **Atualizar URL do Webhook:**
   - Abra `index.html`
   - Encontre a linha:
     ```javascript
     const WEBHOOK_URL = 'https://seu-n8n.cloud/webhook/fitchef';
     ```
   - Substitua pela URL copiada do n8n

2. **Deploy no Vercel (Opção A):**
   ```bash
   # Instalar Vercel CLI
   npm i -g vercel
   
   # Na pasta do projeto
   vercel
   
   # Seguir instruções na tela
   ```

3. **Deploy no Netlify (Opção B):**
   - Acesse https://app.netlify.com
   - Arraste a pasta com os arquivos HTML
   - Deploy automático!

4. **Deploy no GitHub Pages (Opção C):**
   - Crie repositório no GitHub
   - Faça upload dos arquivos
   - Settings → Pages → Deploy from main branch
   - URL: https://seu-usuario.github.io/fitchef-ia

---

## 🔧 CONFIGURAÇÃO AVANÇADA

### Personalizar Receitas

Para adicionar mais receitas ao banco:

```sql
INSERT INTO receitas (nome, ingredientes, modo_preparo, macros, categoria) 
VALUES (
  'Nova Receita',
  ARRAY['ingrediente1', 'ingrediente2'],
  'Modo de preparo detalhado...',
  '{"kcal": 300, "p": 25, "c": 30, "g": 10}'::jsonb,
  'Categoria'
);
```

### Adicionar Autenticação (Opcional)

Se quiser adicionar login futuramente:

1. **No Supabase:**
   ```sql
   -- Criar tabela de usuários favoritos
   CREATE TABLE favoritos (
     id UUID DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id),
     receita_id UUID REFERENCES receitas(id),
     PRIMARY KEY (user_id, receita_id)
   );
   ```

2. **No Frontend:**
   - Integrar Supabase Auth
   - Adicionar botões de login/logout

### Melhorias de Performance

1. **Cache no n8n:**
   - Adicionar nó Redis para cache
   - TTL de 1 hora para receitas

2. **CDN para Assets:**
   - Usar Cloudflare para servir arquivos estáticos
   - Comprimir imagens e CSS

---

## 🧪 TESTES

### Testar Webhook Diretamente

```bash
curl -X POST https://seu-n8n.cloud/webhook/fitchef \
  -H "Content-Type: application/json" \
  -d '{"ingredientes": ["frango", "batata-doce", "brócolis"]}'
```

### Resposta Esperada

```json
{
  "status": "sucesso",
  "total": 3,
  "receitas": [
    {
      "nome": "Frango Grelhado com Batata Doce",
      "ingredientes": ["frango", "batata-doce", "brócolis"],
      "modo_preparo": "...",
      "macros": {"kcal": 380, "p": 42, "c": 35, "g": 6},
      "categoria": "Almoço"
    }
  ]
}
```

---

## 🐛 TROUBLESHOOTING

### Erro: CORS Policy

**Solução:** No n8n, edite o webhook e ative CORS:
```
Options → CORS → Allow Origins: *
```

### Erro: Nenhuma receita encontrada

**Verificar:**
1. Receitas foram inseridas no Supabase?
2. URL e API Key estão corretas no n8n?
3. Ingredientes estão em lowercase?

### Erro: 500 Internal Server Error

**Debug no n8n:**
1. Abrir workflow
2. Clicar em "Executions"
3. Ver log de erro detalhado
4. Corrigir nó com problema

---

## 📊 MONITORAMENTO

### Métricas Importantes

1. **Supabase Dashboard:**
   - Requisições por minuto
   - Tamanho do banco
   - Performance das queries

2. **n8n Executions:**
   - Taxa de sucesso
   - Tempo médio de resposta
   - Erros por dia

3. **Analytics (Opcional):**
   - Adicionar Google Analytics
   - Tracking de buscas mais comuns

---

## 🔐 SEGURANÇA

### Checklist de Segurança

- [x] Usar HTTPS em produção
- [x] API Keys em variáveis de ambiente
- [x] CORS configurado corretamente
- [x] Rate limiting no n8n (100 req/min)
- [x] Validação de entrada no webhook
- [ ] Implementar autenticação (futuro)
- [ ] Backup regular do banco

### Configurar Rate Limiting

No n8n webhook:
```javascript
// Adicionar no nó "Validar Entrada"
const ip = $request.headers['x-forwarded-for'];
// Implementar lógica de rate limit
```

---

## 🚀 PRÓXIMOS PASSOS

### Roadmap de Features

1. **v1.1 - Sistema de Favoritos**
   - Salvar receitas favoritas no localStorage
   - Exportar lista de compras

2. **v1.2 - Filtros Avançados**
   - Filtrar por categoria
   - Filtrar por macros (low-carb, high-protein)
   - Ordenar por calorias

3. **v1.3 - PWA**
   - Funcionar offline
   - Instalar como app
   - Push notifications

4. **v2.0 - Social Features**
   - Compartilhar receitas
   - Avaliar receitas
   - Comentários

---

## 📝 COMANDOS ÚTEIS

### Backup do Banco

```bash
# Exportar todas as receitas
pg_dump -h db.xxxxx.supabase.co -U postgres -d postgres -t receitas > backup.sql
```

### Limpar Cache

```javascript
// No console do browser
localStorage.clear();
sessionStorage.clear();
```

### Debug no Browser

```javascript
// Ver receitas salvas
console.log(JSON.parse(localStorage.getItem('receitas')));

// Testar webhook manual
fetch('https://seu-n8n.cloud/webhook/fitchef', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({ingredientes: ['frango', 'ovo']})
}).then(r => r.json()).then(console.log);
```

---

## 📧 SUPORTE

### Recursos Úteis

- **Supabase Docs:** https://supabase.com/docs
- **n8n Docs:** https://docs.n8n.io
- **Vercel Docs:** https://vercel.com/docs
- **Stack Overflow:** Tag `supabase` ou `n8n`

### Comunidades

- **Supabase Discord:** https://discord.supabase.com
- **n8n Community:** https://community.n8n.io
- **Reddit:** r/webdev, r/selfhosted

---

## 📄 LICENÇA

Este projeto é open source e está disponível sob a licença MIT.

---

## ✅ CHECKLIST FINAL DE DEPLOY

- [ ] Banco Supabase criado e populado
- [ ] n8n workflow importado e ativo
- [ ] Variáveis de ambiente configuradas
- [ ] Webhook URL atualizada no frontend
- [ ] Frontend hospedado (Vercel/Netlify/etc)
- [ ] CORS habilitado no webhook
- [ ] Teste end-to-end funcionando
- [ ] Backup do banco realizado
- [ ] Documentação atualizada
- [ ] Monitoramento configurado

---

**Versão:** 1.0.0
**Última Atualização:** 2024
**Autor:** FitChef IA Team

---

🎉 **PARABÉNS! Seu FitChef IA está pronto para uso!**