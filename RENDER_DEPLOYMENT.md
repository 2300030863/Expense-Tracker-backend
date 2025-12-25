# Render Deployment Guide for Expense Tracker Backend

## 🚀 Quick Deployment Steps

### Step 1: Prepare Your Database

Render's free tier **does NOT support MySQL**. You have two options:

#### Option A: Use External MySQL (Recommended)
Use a free MySQL provider:
- **Railway** (https://railway.app) - Free MySQL
- **PlanetScale** (https://planetscale.com) - Free MySQL
- **Aiven** (https://aiven.io) - Free MySQL trial

#### Option B: Use Render PostgreSQL (Requires Code Changes)
Switch to PostgreSQL (free on Render) - requires updating dependencies.

---

### Step 2: Get Your Database Connection String

From your external MySQL provider, get:
```
Host: your-db-host.com
Port: 3306
Database: expense_tracker
Username: your_username
Password: your_password
```

Create the connection string:
```
jdbc:mysql://your-db-host.com:3306/expense_tracker?useSSL=true&serverTimezone=UTC
```

---

### Step 3: Push Code to GitHub

```bash
git add .
git commit -m "Add Docker configuration for Render deployment"
git push origin main
```

---

### Step 4: Deploy on Render

1. **Go to Render Dashboard** (https://dashboard.render.com)

2. **Create New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select your repository

3. **Configure Service**
   - **Name**: `expense-tracker-backend`
   - **Region**: Choose closest to you (e.g., Oregon)
   - **Branch**: `main`
   - **Runtime**: `Docker`
   - **Plan**: Free

4. **Set Environment Variables** (CRITICAL!)

   Click "Advanced" and add these:

   ```bash
   # Database Configuration (YOUR EXTERNAL MYSQL)
   SPRING_DATASOURCE_URL=jdbc:mysql://YOUR-DB-HOST:3306/expense_tracker?useSSL=true&serverTimezone=UTC
   SPRING_DATASOURCE_USERNAME=your_db_username
   SPRING_DATASOURCE_PASSWORD=your_db_password
   
   # JWT Secret (Generate a NEW random string)
   SPRING_SECURITY_JWT_SECRET=CHANGE_THIS_TO_A_VERY_LONG_RANDOM_STRING_AT_LEAST_64_CHARACTERS_LONG
   SPRING_SECURITY_JWT_EXPIRATION=86400000
   
   # Email Configuration
   SPRING_MAIL_HOST=smtp.gmail.com
   SPRING_MAIL_PORT=587
   SPRING_MAIL_USERNAME=your-email@gmail.com
   SPRING_MAIL_PASSWORD=your-gmail-app-password
   SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH=true
   SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE=true
   SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_REQUIRED=true
   APP_EMAIL_FROM=your-email@gmail.com
   
   # Spring Profile
   SPRING_PROFILES_ACTIVE=mysql
   
   # Server Configuration
   SERVER_SERVLET_CONTEXT_PATH=/expense-tracker-api
   
   # Logging (Set to INFO for production)
   LOGGING_LEVEL_COM_EXPENSETRACKER=INFO
   LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_SECURITY=INFO
   ```

5. **Create Web Service**
   - Click "Create Web Service"
   - Render will automatically build your Docker image
   - Wait for deployment (5-10 minutes)

---

### Step 5: Get Your API URL

After deployment, Render will provide a URL like:
```
https://expense-tracker-backend.onrender.com
```

Your API will be available at:
```
https://expense-tracker-backend.onrender.com/expense-tracker-api
```

---

## 🔧 Testing Your Deployment

### Test Health (if you have actuator)
```bash
curl https://your-app.onrender.com/expense-tracker-api/actuator/health
```

### Test a Public Endpoint
```bash
curl https://your-app.onrender.com/expense-tracker-api/auth/login
```

---

## 📧 Gmail App Password Setup

1. Go to your Google Account: https://myaccount.google.com/
2. Security → 2-Step Verification (enable if not enabled)
3. Security → App passwords
4. Create app password for "Mail"
5. Copy the 16-character password
6. Use this in `SPRING_MAIL_PASSWORD` environment variable

---

## ⚠️ Common Issues & Solutions

### Issue 1: Connection Refused / Database Error
**Cause**: Database not accessible from Render
**Solution**: 
- Ensure your external MySQL allows connections from Render's IP
- Check firewall settings
- Verify connection string is correct

### Issue 2: Port Binding Error
**Cause**: App not listening on Render's assigned PORT
**Solution**: 
- Already fixed! Our Dockerfile uses `$PORT` environment variable
- Render automatically sets this

### Issue 3: Build Fails
**Cause**: Maven dependencies download issues
**Solution**: 
- Check pom.xml is in repository root
- Try re-deploying

### Issue 4: App Crashes on Startup
**Cause**: Missing environment variables
**Solution**: 
- Double-check all required env vars are set in Render dashboard
- Check logs in Render dashboard

---

## 🔍 Viewing Logs

1. Go to Render Dashboard
2. Click your service
3. Click "Logs" tab
4. View real-time logs

---

## 💰 Free Tier Limitations

- **Spins down after 15 minutes of inactivity**
- First request after inactivity takes ~30 seconds (cold start)
- 750 hours/month free
- No MySQL database included (use external)

---

## 🔄 Auto-Deploy Setup

Render auto-deploys on every push to your connected branch:

```bash
git add .
git commit -m "Update feature"
git push origin main
# Render automatically rebuilds and deploys
```

---

## 📊 Next Steps

1. ✅ Deploy to Render
2. ✅ Test all endpoints
3. ✅ Update frontend to use Render API URL
4. ✅ Monitor logs for errors
5. ✅ Consider upgrading to paid tier for no downtime

---

## 🆘 Need Help?

- Render Docs: https://render.com/docs
- Check logs in Render dashboard
- Verify environment variables
- Test database connection separately

---

**Your API Base URL Structure:**
```
https://your-app-name.onrender.com/expense-tracker-api
```

**Example Endpoints:**
- Login: `POST https://your-app-name.onrender.com/expense-tracker-api/auth/login`
- Register: `POST https://your-app-name.onrender.com/expense-tracker-api/auth/register`
- Transactions: `GET https://your-app-name.onrender.com/expense-tracker-api/transactions`
