# Contributing to VPN Auto Script

First off, thank you for considering contributing to VPN Auto Script! It's people like you that make this project better for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

---

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

- Be respectful and inclusive
- Welcome newcomers
- Focus on what is best for the community
- Show empathy towards others

---

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce**
- **Expected vs actual behavior**
- **System information** (OS, version, etc.)
- **Screenshots** if applicable

**Bug Report Template:**

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**System Info:**
- OS: [e.g., Ubuntu 22.04]
- Script Version: [e.g., 2.0.0]
- Domain: Yes/No

**Screenshots**
If applicable, add screenshots.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Why this enhancement would be useful**
- **Possible implementation** (if you have ideas)

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🛠️ Development Setup

### Prerequisites

- Ubuntu 20.04+ or Debian 9+
- Root access
- Domain name (for testing)
- Git installed

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz.git
cd tunnel

# Create development branch
git checkout -b dev-yourname

# Install dependencies (if testing)
apt-get update
apt-get install -y jq curl wget
```

### Testing Your Changes

```bash
# Make your changes
nano tunnel.sh

# Make executable
chmod +x tunnel.sh

# Test on clean VPS
./tunnel.sh
```

---

## 📏 Coding Standards

### Bash Script Guidelines

1. **Use 4 spaces for indentation** (no tabs)
2. **Add comments** for complex logic
3. **Use meaningful variable names**
   ```bash
   # Good
   USERNAME="johndoe"
   DOMAIN="example.com"
   
   # Bad
   u="johndoe"
   d="example.com"
   ```

4. **Check for errors**
   ```bash
   # Good
   if [[ $? -eq 0 ]]; then
       echo "Success"
   else
       echo "Failed"
       return 1
   fi
   ```

5. **Use functions for reusable code**
   ```bash
   create_account() {
       local username="$1"
       local days="$2"
       # ... implementation
   }
   ```

6. **Validate user input**
   ```bash
   read -p "Days: " days
   if [[ ! "$days" =~ ^[0-9]+$ ]]; then
       echo "Invalid input"
       return 1
   fi
   ```

### Color Code Usage

Use defined color variables:
```bash
echo -e "${GREEN}Success${NC}"
echo -e "${RED}Error${NC}"
echo -e "${CYAN}Info${NC}"
echo -e "${YELLOW}Warning${NC}"
```

### Error Handling

Always handle errors gracefully:
```bash
# Check if file exists
if [[ ! -f "$file" ]]; then
    echo -e "${RED}File not found${NC}"
    return 1
fi

# Check if command succeeded
if ! systemctl restart xray; then
    echo -e "${RED}Failed to restart Xray${NC}"
    return 1
fi
```

---

## 💬 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples

```bash
feat(vmess): add support for port 2096

- Added 2096 to VMess TLS ports
- Updated config generation
- Updated documentation

Closes #123
```

```bash
fix(xray): resolve permission issues

- Fixed file permissions on config
- Added auto-fix on startup
- Added error handling

Fixes #456
```

---

## 🔄 Pull Request Process

1. **Update documentation** if adding features
2. **Test thoroughly** on clean VPS
3. **Update CHANGELOG.md** with your changes
4. **Ensure code follows** coding standards
5. **Add comments** for complex logic
6. **Squash commits** if multiple small commits
7. **Wait for review** from maintainers

### Pull Request Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
How has this been tested?
- [ ] Fresh Ubuntu 22.04
- [ ] Fresh Debian 11
- [ ] Existing installation

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tested on clean VPS

## Screenshots (if applicable)
Add screenshots showing the changes.
```

---

## 🧪 Testing

### Manual Testing Checklist

Before submitting a PR, test:

- [ ] Fresh installation works
- [ ] All menu options functional
- [ ] Account creation works (all protocols)
- [ ] Account deletion works
- [ ] Services start correctly
- [ ] SSL certificate generation works
- [ ] No error messages in logs
- [ ] System optimization applied
- [ ] Telegram bot works (if applicable)

### Test Environments

Preferred test environments:
- Ubuntu 22.04 (primary)
- Ubuntu 20.04
- Debian 11
- Debian 10

### Reporting Test Results

When reporting test results:
```markdown
**Test Environment:**
- OS: Ubuntu 22.04
- RAM: 1GB
- Storage: 25GB

**Test Results:**
✅ Installation successful
✅ VMess account creation works
✅ VLESS account creation works
❌ Telegram bot connection failed (will fix)
✅ Services running
✅ No errors in logs

**Notes:**
Connection stable for 30 minutes of testing.
```

---

## 📝 Documentation

### Updating Documentation

When adding features, update:
- `README.md` - Main documentation
- `CHANGELOG.md` - Version history
- `VPN-STABILITY-GUIDE.md` - If affecting stability
- Code comments - Inline documentation

### Documentation Style

- Use clear, concise language
- Include code examples
- Add screenshots when helpful
- Keep formatting consistent
- Use proper markdown syntax

---

## 🎯 Areas We Need Help

Current areas where contributions are welcome:

1. **Testing on different OS versions**
2. **Translation to other languages**
3. **Performance optimization**
4. **Bug fixes**
5. **Documentation improvements**
6. **New protocol support**
7. **UI/UX enhancements**

---

## 💡 Questions?

If you have questions about contributing:

- Open a [Discussion](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/discussions)
- Join our [Telegram Group](https://t.me/yourgroup)
- Email: support@yourdomain.com

---

## 🌟 Recognition

Contributors will be:
- Listed in `CHANGELOG.md`
- Mentioned in release notes
- Added to `README.md` contributors section

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to VPN Auto Script! 🎉

**Made with ❤️ by The Proffessor Squad**
